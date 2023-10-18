//
//  SidebarView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI
import TipKit

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilters: [Filter] = [.all, .recent]
    
    @State private var identityToRename: Identity?
    @State private var renamingIdentity = false
    @State private var identityName = ""
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var identities: FetchedResults<Identity>
    
    var identityFilters: [Filter] {
        identities.map { identity in
            Filter(id: identity.identityID , name: identity.identityName , icon: identity.identityIcon, identity: identity)
        }
    }
    
    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            Section("Identities") {
                ForEach(identityFilters) { filter in
                    UserFilterRow(filter: filter, rename: rename, delete: delete)
                }
            }
        }
        .navigationTitle("Daily Catalyst")
        .toolbar(content: SidebarViewToolbar.init)
        .alert("Rename Identity", isPresented: $renamingIdentity) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("Rename", text: $identityName)
        }
    }
    
    func rename(_ filter: Filter) {
        identityToRename = filter.identity
        identityName = filter.name
        renamingIdentity = true
    }
    
    func completeRename() {
        identityToRename?.name = identityName
        dataController.save()
    }
    
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = identities[offset]
            dataController.delete(item)
        }
    }
    
    func delete(_ filter: Filter) {
        guard let identity = filter.identity else { return }
        dataController.delete(identity)
        dataController.save()
    }
}

struct AddMenuTip: Tip {
    var title: Text {
        Text("Tap here to…")
    }
    
    var message: Text? {
        Text("""
    - Add Catalyst or Identity.
    - Add test sample data.
    """)
    }
    
    var image: Image? {
        Image(systemName: "plus.square.on.square")
    }
}

#Preview {
    SidebarView()
        .environmentObject(DataController.preview)
}
