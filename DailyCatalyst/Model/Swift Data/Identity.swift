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
    var name: String
    var creationDate: Date
    var icon: String
    
    @Relationship(inverse: \Catalyst.identity)
    var catalysts: [Catalyst]
    
    init(name: String, creationDate: Date, icon: String, catalysts: [Catalyst]) {
        self.name = name
        self.creationDate = creationDate
        self.icon = icon
        self.catalysts = catalysts
    }
}

extension Identity {
    static var example: Identity {
        Identity(name: "Identity", creationDate: .now, icon: "person", catalysts: [.example])
    }
}

extension Identity: Comparable {
    public static func <(lhs: Identity, rhs: Identity) -> Bool {
        let left = lhs.name.localizedLowercase
        let right = rhs.name.localizedLowercase
        
        if left == right {
            return lhs.id < rhs.id
        } else {
            return left < right
        }
    }
}
