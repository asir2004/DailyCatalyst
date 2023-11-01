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
    
    @State private var showNewCatalyst = false
    @State private var showNewIdentity = false
    @State private var showingAwards = false
    @State private var showingSettings = false
    
    var identityFilters: [Filter] {
        identities.map { identity in
            Filter(id: identity.identityID , name: identity.identityName , icon: identity.identityIcon, identity: identity)
        }
    }
    
    var body: some View {
        ZStack {
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
            
            VStack {
                Spacer()
                
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
                    Label("Add", systemImage: "plus")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Circle().foregroundColor(.accentColor))
                }
                .labelStyle(.iconOnly)
                .padding()
            }
        }
        .navigationTitle("Daily Catalyst")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
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
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showingSettings.toggle()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
                .popoverTip(AddMenuTip(), arrowEdge: .top)
            }
        }
        .alert("Rename Identity", isPresented: $renamingIdentity) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("Rename", text: $identityName)
        }
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
        .sheet(isPresented: $showingAwards) {
            AwardsView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
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
