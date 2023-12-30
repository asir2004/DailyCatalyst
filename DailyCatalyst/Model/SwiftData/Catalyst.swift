//
//  Catalyst.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 12/16/23.
//

import Foundation
import SwiftData

@Model
final class Catalyst {
    var title: String
    var happeningDate: Date
    var creationDate: Date
    var archived: Bool
    var happiness: Int
    var identity: Identity
    
    init(title: String, happeningDate: Date, creationDate: Date, archived: Bool, happiness: Int, identity: Identity) {
        self.title = title
        self.happeningDate = happeningDate
        self.creationDate = creationDate
        self.archived = archived
        self.happiness = happiness
        self.identity = identity
    }
    
    var catalystStatus: String {
        if archived {
            return "Archived"
        } else {
            return "Open"
        }
    }
    
    var creationDateFormatted: String {
        creationDate.formatted(date: .numeric, time: .omitted)
    }
}

extension Catalyst {
    static var example: Catalyst {
        Catalyst(title: "Example", happeningDate: .now, creationDate: .now, archived: false, happiness: 3, identity: .example)
    }
}

extension Catalyst: Comparable {
    public static func <(lhs: Catalyst, rhs: Catalyst) -> Bool {
        let left = lhs.title.localizedLowercase
        let right = rhs.title.localizedLowercase
        
        if left == right {
            return lhs.creationDate < rhs.creationDate
        } else {
            return left < right
        }
    }
}
