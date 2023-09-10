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
    
    @State private var showNewCatalyst = false
    @State private var showNewIdentity = false
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var identities: FetchedResults<Identity>
    
    var identityFilters: [Filter] {
        identities.map { identity in
            Filter(id: identity.identityID , name: identity.identityName , icon: "tag", identity: identity)
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
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                            .badge(filter.identity?.identityActiveCatalysts.count ?? 0)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Daily Catalyst")
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
        .toolbar {
            Menu("Add") {
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
            }
            .popoverTip(AddMenuTip(), arrowEdge: .top)
        }
    }
    
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = identities[offset]
            dataController.delete(item)
        }
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

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(DataController.preview)
    }
}
