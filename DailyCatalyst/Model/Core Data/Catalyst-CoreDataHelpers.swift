//
//  Catalyst-CoreDataHelpers.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import Foundation
import SwiftUI

extension Catalyst {
    var catalystTitle: String {
        get { title ?? "" }
        set { title = newValue}
    }
    
    var catalystEffect: String {
        get { effect ?? "" }
        set { effect = newValue}
    }
    
    var catalystCreationDate: Date {
        creationDate ?? .now
    }
    
    var catalystHappeningDate: Date {
        happeningDate ?? .now
    }
    
    var catalystModificationDate: Date {
        modificationDate ?? .now
    }
    
    var catalystIdentities: [Identity] {
        let result = identities?.allObjects as? [Identity] ?? []
//        let result = identities ?? []
        return result.sorted()
    }
    
    var catalystIdentitiesList: String {
        guard let identities else { return "No Identities"}
        
        if identities.count == 0 {
            return "No Identities"
        } else {
            return catalystIdentities.map(\.identityName).formatted()
        }
    }
    
    var catalystStatus: String {
        if archived {
            return "Archived"
        } else {
            return "Open"
        }
    }
    
    var catalystCreationDateFormatted: String {
        catalystCreationDate.formatted(date: .numeric, time: .omitted)
    }
    
//    static var example: Catalyst {
//        let controller = DataController(inMemory: true)
//        let viewContext = controller.container.viewContext
//        
//        let catalyst = Catalyst(context: viewContext)
//        catalyst.title = "Example Catalyst"
//        catalyst.effect = "Example Effect"
//        catalyst.happeningDate = .now.addingTimeInterval(86400)
//        catalyst.creationDate = .now
//        catalyst.happiness = Int16.random(in: 1...5)
//        catalyst.archived = false
//        catalyst.addToIdentities(.example)
//        
//        return catalyst
//    }
    
    // Core Data examples used before

    static var example: Catalyst {
        let result = DataController.preview
        let viewContext = result.container.viewContext
        let catalyst = Catalyst(context: viewContext)
        catalyst.title = "An example catalyst"
        catalyst.effect = "Details of example catalyst"
        catalyst.happiness = 3
        catalyst.archived = false
        catalyst.happeningDate = .now
        
        return catalyst
    }
    
    static var example2: Catalyst {
        let viewContext = DataController().container.viewContext
        let catalyst = Catalyst(context: viewContext)
        catalyst.title = "Example 2"
        catalyst.effect = "Example 2 Detail"
        catalyst.happiness = 1
        catalyst.archived = true
        catalyst.happeningDate = .now
        
        return catalyst
    }
}

extension Catalyst: Comparable {
    public static func <(lhs: Catalyst, rhs: Catalyst) -> Bool {
        let left = lhs.catalystTitle.localizedLowercase
        let right = rhs.catalystTitle.localizedLowercase
        
        if left == right {
            return lhs.catalystCreationDate < rhs.catalystCreationDate
        } else {
            return left < right
        }
    }
}
