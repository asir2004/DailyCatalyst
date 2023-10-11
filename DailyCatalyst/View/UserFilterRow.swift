//
//  UserFilterRow.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/11/23.
//

import SwiftUI

struct UserFilterRow: View {
    @EnvironmentObject var dataController: DataController
    var filter: Filter
    var rename: (delete) -> Void
    var delete: (delete) -> Void
    
    var body: some View {
        NavigationLink(value: filter) {
            Label(filter.name, systemImage: filter.icon)
                .badge(filter.identity?.identityActiveCatalysts.count ?? 0)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        delete(filter)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        rename(filter)
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                }
                .accessibilityElement()
                .accessibilityLabel(filter.name)
                .accessibilityHint("^[\(filter.activeCatalystsCount) Catalyst](inflect: true)")
        }
    }
}
