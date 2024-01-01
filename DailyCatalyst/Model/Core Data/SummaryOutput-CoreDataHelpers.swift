//
//  SummaryOutput-CoreDataHelpers.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 1/1/24.
//

import Foundation

extension SummaryOutput {
    var summaryId: UUID {
        id ?? UUID()
    }
    
    var summaryDetail: String {
        detail ?? ""
    }
    
    var summaryCreationDate: Date {
        creationDate ?? .now
    }
    
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

extension SummaryOutput: Comparable {
    public static func <(lhs: SummaryOutput, rhs: SummaryOutput) -> Bool {
        let left = lhs.summaryDetail
        let right = rhs.summaryDetail
        
        if left == right {
            return lhs.summaryId.uuidString < rhs.summaryId.uuidString
        } else {
            return left < right
        }
    }
}
