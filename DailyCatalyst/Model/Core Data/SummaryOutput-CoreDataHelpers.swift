//
//  SummaryOutput-CoreDataHelpers.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 1/1/24.
//

import Foundation

extension SummaryOutput {
    static var example: SummaryOutput {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let summary = SummaryOutput(context: viewContext)
        summary.id = UUID()
        summary.detail = """
**What a great day!**

You have met many great, creative people!
"""
        summary.creationDate = .now
        
        return summary
    }
    
    static var example2: SummaryOutput {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let summary = SummaryOutput(context: viewContext)
        summary.id = UUID()
        summary.detail = """
**What a nice day!**
"""
        summary.creationDate = .now
        
        return summary
    }
}
