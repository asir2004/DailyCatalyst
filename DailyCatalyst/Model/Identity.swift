//
//  Identity.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/15/23.
//
//

import Foundation
import SwiftData


@Model public class Identity {
    var color: String?
    var creationDate: Date?
    var icon: String?
    var id: UUID?
    var name: String?
    var catalysts: [Catalyst]?
    public init() {

    }
    
}
