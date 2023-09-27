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
    
    @State private var identityToRename: Identity?
    @State private var renamingIdentity = false
    @State private var identityName = ""
    
    @State private var showingAwards = false
    
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
//                            .swipeActions(edge: .leading) {
//                                Button {
//                                    rename(filter)
//                                } label: {
//                                    Label("Rename", systemImage: "pencil")
//                                }
//                                Button(role: .destructive) {
//                                    delete(offsets)
//                                } label: {
//                                    Label("Delete", systemImage: "trash")
//                                }
//                            }
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
                    showingAwards.toggle()
                } label: {
                    Label("Show Awards", systemImage: "rosette")
                }
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
        .alert("Rename Identity", isPresented: $renamingIdentity) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("Rename", text: $identityName)
        }
        .sheet(isPresented: $showingAwards, content: AwardsView.init)
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
