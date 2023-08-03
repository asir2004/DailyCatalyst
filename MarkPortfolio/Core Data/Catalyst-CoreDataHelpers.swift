//
//  Catalyst-CoreDataHelpers.swift
//  MarkPortfolio
//
//  Created by Asir Bygud on 8/3/23.
//

import Foundation

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
    
    var catalystModificationDate: Date {
        modificationDate ?? .now
    }
    
    var catalystTags: [Tag] {
        let result = tags?.allObjects as? [Tag] ?? []
        return result.sorted()
    }
    
    var catalystTagsList: String {
        guard let tags else { return "No Tags"}
        
        if tags.count == 0 {
            return "No Tags"
        } else {
            return catalystTags.map(\.tagName).formatted()
        }
    }
    
    var catalystStatus: String {
        if archived {
            return "Archived"
        } else {
            return "Open"
        }
    }
    
    static var example: Catalyst {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let catalyst = Catalyst(context: viewContext)
        catalyst.title = "Example Catalyst"
        catalyst.effect = "Example Effect"
        catalyst.happiness = Int16.random(in: 1...5)
        catalyst.creationDate = .now
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
