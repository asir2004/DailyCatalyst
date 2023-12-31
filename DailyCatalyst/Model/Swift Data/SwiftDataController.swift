//
//  SwiftDataController.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 12/29/23.
//

import Foundation
import SwiftData
import SwiftUI

class SwiftDataController {
    func catalystsForSelectedIdentity(identity: Identity?) -> [Catalyst] {
        @Query(sort: \Catalyst.happeningDate) var catalystsQuery: [Catalyst]
        
        var catalysts = catalystsQuery
        
        if let identity = identity {
            ForEach(catalysts) { catalyst in
                if catalyst.identity != identity || catalyst.identity == nil {
                    catalysts.remove(at: catalysts.firstIndex(of: catalyst)!)
                }
            }
        }
    }
}
