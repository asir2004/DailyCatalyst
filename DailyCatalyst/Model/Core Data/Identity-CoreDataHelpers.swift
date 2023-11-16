//
//  Identity-CoreDataHelpers.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import Foundation

extension Identity {
    var identityID: UUID {
        id ?? UUID()
    }

    var identityName: String {
        name ?? ""
    }

    var identityIcon: String {
        icon ?? "person"
    }
    
    var identityCreationDateFormatted: String {
        if creationDate != nil {
            creationDate!.formatted(date: .numeric, time: .omitted)
        } else {
            "No Date"
        }
    }

    var identityActiveCatalysts: [Catalyst] {
        let result = catalysts?.allObjects as? [Catalyst] ?? []
//        let result = catalysts ?? []
        return result.filter { $0.archived == false }
    }

    static var example: Identity {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let identity = Identity(context: viewContext)
        identity.id = UUID()
        identity.name = "Example Identity"
        identity.color = "Green"
        return identity
    }
}

extension Identity: Comparable {
    public static func <(lhs: Identity, rhs: Identity) -> Bool {
        let left = lhs.identityName.localizedLowercase
        let right = rhs.identityName.localizedLowercase
        
        if left == right {
            return lhs.identityID.uuidString < rhs.identityID.uuidString
        } else {
            return left < right
        }
    }
    
    // Modified after SwiftData
    
//    public static func < (lhs: Identity, rhs: Identity) -> Bool {
//        let left = lhs.identityName.localizedLowercase
//        let right = rhs.identityName.localizedLowercase
//        
//        if left == right {
//            return lhs.identityID.uuidString < rhs.identityID.uuidString
//        } else {
//            return left < right
//        }
//    }
//    
//    public static func == (lhs: Identity, rhs: Identity) -> Bool {
//        return lhs.identityID == rhs.identityID
//    }
}
