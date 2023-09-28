//
//  DataController.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/1/23.
//

import CoreData

enum SortType: String {
    case dateCreated = "creationDate"
    case dateModified = "modificationDate"
    case dateHappened = "happeningDate"
}

enum Status {
    case all, open, archived
}

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    @Published var selectedFilter: Filter? = Filter.all
    @Published var selectedCatalyst: Catalyst?
    
    @Published var filterText = ""
    @Published var filterTokens = [Identity]()
    
    @Published var filterEnabled = false
    @Published var filterHappiness = -1 // Means any happiness
    @Published var filterStatus = Status.all
    @Published var sortType = SortType.dateCreated
    @Published var sortNewestFirst = true
    
    private var saveTask: Task<Void, Error>?
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator, queue: .main, using: remoteStoreChanged)
        
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }
    
    func createSampleData() {
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let identity = Identity(context: viewContext)
            identity.id = UUID()
            identity.name = "Identity \(i)"
            
            for j in 1...10 {
                let catalyst = Catalyst(context: viewContext)
                catalyst.title = "Catalyst \(i)-\(j)"
                catalyst.effect = "Description goes here."
                catalyst.creationDate = .now
                catalyst.happeningDate = .now
                catalyst.archived = Bool.random()
                catalyst.happiness = Int16.random(in: 1...5)
                identity.addToCatalysts(catalyst)
            }
        }
        
        try? viewContext.save()
    }
    
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
    func queueSave() {
        saveTask?.cancel()
        
        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }
    
    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }
    
    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = Identity.fetchRequest()
        delete(request1)

        let request2: NSFetchRequest<NSFetchRequestResult> = Catalyst.fetchRequest()
        delete(request2)

        save()
    }
    
    func missingIdentities(from catalyst: Catalyst) -> [Identity] {
        let request = Identity.fetchRequest()
        let allIdentities = (try? container.viewContext.fetch(request)) ?? []
        
        let allIdentitiesSet = Set(allIdentities)
        let difference = allIdentitiesSet.symmetricDifference(catalyst.catalystIdentities)
        
        return difference.sorted()
    }
    
    func allIdentities() -> [Identity] {
        let request = Identity.fetchRequest()
        let allIdentities = (try? container.viewContext.fetch(request)) ?? []
        
        return allIdentities.sorted()
    }
    
    func catalystsForSelectedFilter() -> [Catalyst] {
        let filter = selectedFilter ?? .all
        var predicates = [NSPredicate]()
        
        if let identity = filter.identity {
            let identityPredicate = NSPredicate(format: "identities CONTAINS %@", identity)
            predicates.append(identityPredicate)
        } else {
            let datePredicate = NSPredicate(format: "modificationDate > %@", filter.minModificationDate as NSDate)
            predicates.append(datePredicate)
        }
        
        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)
        
        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", trimmedFilterText)
            let effectPredicate = NSPredicate(format: "effect CONTAINS[c] %@", trimmedFilterText)
            let combinedPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, effectPredicate])
            predicates.append(combinedPredicate)
        }
        
        if filterTokens.isEmpty == false {
            for filterToken in filterTokens {
                let tokenPredicate = NSPredicate(format: "identities CONTAINS %@", filterToken)
                predicates.append(tokenPredicate)
            }
        }
        
        if filterEnabled {
            if filterHappiness >= 0 {
                let happinessFilter = NSPredicate(format: "happiness = %d", filterHappiness)
                predicates.append(happinessFilter)
            }

            if filterStatus != .all {
                let lookForArchived = filterStatus == .archived
                let statusFilter = NSPredicate(format: "archived = %@", NSNumber(value: lookForArchived))
                predicates.append(statusFilter)
            }
        }
        
        let request = Catalyst.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]
        
        let allCatalysts = (try? container.viewContext.fetch(request)) ?? []
        return allCatalysts.sorted()
    }
    
    var suggestedFilterTokens: [Identity] {
        guard filterText.starts(with: "#") else {
            return []
        }

        let trimmedFilterText = String(filterText.dropFirst()).trimmingCharacters(in: .whitespaces)
        let request = Identity.fetchRequest()

        if trimmedFilterText.isEmpty == false {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", trimmedFilterText)
        }

        return (try? container.viewContext.fetch(request).sorted()) ?? []
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
}
