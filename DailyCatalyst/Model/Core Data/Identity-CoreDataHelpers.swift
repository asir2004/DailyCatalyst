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
    
    var identityActiveCatalysts: [Catalyst] {
        let result = catalysts?.allObjects as? [Catalyst] ?? []
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
}
