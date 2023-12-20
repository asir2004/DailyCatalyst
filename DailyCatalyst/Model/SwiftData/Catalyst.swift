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
    var id: UUID
    var title: String
    var happeningDate: Date
    var creationDate: Date
    var archived: Bool
    var happiness: Int
    var identity: Identity
    
    init(id: UUID, title: String, happeningDate: Date, creationDate: Date, archived: Bool, happiness: Int, identity: Identity) {
        self.id = id
        self.title = title
        self.happeningDate = happeningDate
        self.creationDate = creationDate
        self.archived = archived
        self.happiness = happiness
        self.identity = identity
    }
}

extension Catalyst {
    static var example: Catalyst {
        Catalyst(id: UUID(), title: "Example", happeningDate: .now, creationDate: .now, archived: false, happiness: 3, identity: .example)
    }
}
