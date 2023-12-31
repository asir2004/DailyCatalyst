//
//  Filter.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import Foundation
import SwiftUI

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var identity: Identity?
    
    var activeCatalystsCount: Int {
        identity?.identityActiveCatalysts.count ?? 0
    }
    
    static var all = Filter(id: UUID(), name: "All Catalysts", icon: "tray")
    static var recent = Filter(id: UUID(), name: "Recent Catalysts", icon: "clock", minModificationDate: .now.addingTimeInterval(86400 * -7))
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
