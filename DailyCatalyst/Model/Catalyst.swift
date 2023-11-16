//
//  Catalyst.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/15/23.
//
//

import Foundation
import SwiftData


@Model public class Catalyst {
    var archived: Bool = false
    var creationDate: Date?
    var effect: String?
    var emoji: String?
    var happeningDate: Date?
    var happiness: Int16? = 0
    @Attribute(.externalStorage) var image: Data?
    var modificationDate: Date?
    var title: String?
    @Relationship(inverse: \Identity.catalysts) var identities: [Identity]?
    public init() {

    }
    

#warning("The property \"derived\" on Catalyst:modificationDate is unsupported in SwiftData.")

}
