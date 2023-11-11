//
//  DataController.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/1/23.
//

import CoreData
import SwiftUI

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
    
//    static var preview: DataController = {
//        let dataController = DataController(inMemory: true)
//        dataController.createSampleData()
//        return dataController
//    }()
    
    static var preview: DataController = {
        let result = DataController(inMemory: true)
        let viewContext = result.container.viewContext
        let newIdentity = Identity(context: viewContext)
        newIdentity.name = "Identity Name"
        newIdentity.icon = "person"
        newIdentity.color = "red"
        newIdentity.creationDate = .now
        
        let newCatalyst = Catalyst(context: viewContext)
        newCatalyst.title = "Catalyst Title"
        newCatalyst.effect = "Catalyst Effect"
        newCatalyst.happiness = 3
        newCatalyst.archived = false
        newCatalyst.creationDate = .now
//        newCatalyst.modificationDate = .now
        newCatalyst.happeningDate = .now
        newCatalyst.addToIdentities(newIdentity)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
//        result.createSampleData()
        return result
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
//        let url = URL.storeURL(for: "group.com.markview.dailycatalyst", databaseName: "DailyCatalyst")
//        let storeDescription = NSPersistentStoreDescription(url: url)
//        container.persistentStoreDescriptions = [storeDescription]
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        
        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )
        
        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main,
            using: remoteStoreChanged
        )
        
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
        
        for identityCount in 1...5 {
            let identity = Identity(context: viewContext)
            identity.id = UUID()
            identity.name = "Identity \(identityCount)"
            
            for catalystCount in 1...10 {
                let catalyst = Catalyst(context: viewContext)
                catalyst.title = "Catalyst \(identityCount)-\(catalystCount)"
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
        return allCatalysts
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
    
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "catalysts":
            let fetchRequest = Catalyst.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "identities":
            let fetchRequest = Identity.fetchRequest()
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
            
        default:
//            fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
    
    
    /// Copied from https://stackoverflow.com/questions/34917149/how-to-randomly-choose-an-element-from-coredata-swift
    
    func randomlyPickACatalyst() -> Catalyst {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Catalyst")
        
        let moc = container.viewContext
        
        if let fetchRequestCount = try? moc.count(for: fetchRequest) {
            fetchRequest.fetchOffset = Int.random(in: 0...fetchRequestCount)
        }

        fetchRequest.fetchLimit = 1

        var fetchResults: [Catalyst]?
        moc.performAndWait {
            fetchResults = try? fetchRequest.execute() as? [Catalyst]
        }

        if let wrapFetchResults = fetchResults {
            if wrapFetchResults.count > 0 {
                return wrapFetchResults.first ?? .example
            } else {
                return .example
            }
        } else {
            return .example
        }
    }
}

//public extension URL {
//    static func storeURL(for appGroup: String, databaseName: String) -> URL {
//        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
//            fatalError("Unable to create URL for \(appGroup)")
//        }
//        
//        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
//    }
//}
