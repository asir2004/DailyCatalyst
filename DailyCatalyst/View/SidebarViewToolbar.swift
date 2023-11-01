//
//  SidebarViewToolbar.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/9/23.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        Menu {
            Button {
                dataController.createSampleData()
            } label: {
                Label("Add Samples", systemImage: "flame")
            }
            Button {
                dataController.deleteAll()
            } label: {
                Label("Delete All", systemImage: "trash")
            }
        } label: {
            Label("Test", systemImage: "flask")
        }
    }
}

#Preview {
    SidebarViewToolbar()
}
