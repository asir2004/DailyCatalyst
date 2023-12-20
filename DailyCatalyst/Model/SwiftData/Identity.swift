//
//  Identity.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 12/16/23.
//

import Foundation
import SwiftData

@Model
final class Identity {
    var id: UUID
    var name: String
    var creationDate: Date
    var icon: String
    
    @Relationship(inverse: \Catalyst.identity)
    var catalysts: [Catalyst]
    
    init(id: UUID, name: String, creationDate: Date, icon: String, catalysts: [Catalyst]) {
        self.id = id
        self.name = name
        self.creationDate = creationDate
        self.icon = icon
        self.catalysts = catalysts
    }
}

extension Identity {
    static var example: Identity {
        Identity(id: UUID(), name: "Identity", creationDate: .now, icon: "person", catalysts: [.example])
    }
}
