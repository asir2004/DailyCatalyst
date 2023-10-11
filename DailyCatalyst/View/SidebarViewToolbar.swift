//
//  SidebarViewToolbar.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/9/23.
//

import SwiftUI

struct SidebarViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingAwards = false
    @State private var showNewCatalyst = false
    @State private var showNewIdentity = false
    
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
        
        Button {
            showingAwards.toggle()
        } label: {
            Label("Show Awards", systemImage: "rosette")
        }
        
        Menu {
            Button {
                showNewCatalyst = true
            } label: {
                Image(systemName: "flask")
                Text("Catalyst")
            }
            Button {
                showNewIdentity = true
            } label: {
                Image(systemName: "person")
                Text("Identity")
            }
        } label: {
            Text("Add")
        }
        .popoverTip(AddMenuTip(), arrowEdge: .top)
        .sheet(isPresented: $showNewCatalyst) {
            NavigationStack {
                NewCatalystView()
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showNewIdentity) {
            NavigationStack {
                NewIdentityView()
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    SidebarViewToolbar()
}