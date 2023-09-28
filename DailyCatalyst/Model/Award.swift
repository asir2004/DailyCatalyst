//
//  Award.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 9/27/23.
//

import Foundation

struct Award: Decodable, Identifiable {
    var id: String { name }
    var name: String
    var description: String
    var color: String
    var criterion: String
    var value: Int
    var image: String
    
    // Make the Awards.json by yourself.
    static let allAwards = Bundle.main.decode("Awards.json", as: [Award].self)
    static let example = allAwards[0]
}
