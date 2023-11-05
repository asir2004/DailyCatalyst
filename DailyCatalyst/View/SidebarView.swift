//
//  SidebarView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI
import TipKit
import SymbolPicker

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilters: [Filter] = [.all, .recent]
    
    @AppStorage("hideNavBarOnSwipe") var hideNavBarOnSwipe = true
    
    @State private var identityToRename: Identity?
    @State private var renamingIdentity = false
//    @State private var identityName = ""
//    @State private var identityIcon = ""
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var identities: FetchedResults<Identity>
    
    @State private var showNewCatalyst = false
    @State private var showNewIdentity = false
    @State private var showDimmingAddScreen = false
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
            
            if showDimmingAddScreen {
                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                VStack {
                    Button {
                        showNewCatalyst = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 100)
                                .foregroundStyle(.thinMaterial)
                                .shadow(color: .black.opacity(0.1), radius: 10, y: 10)
                            
                            HStack {
                                Image(systemName: "flask")
                                    .imageScale(.large)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Circle().foregroundColor(.accentColor))
                                
                                Text("Catalyst")
                                    .font(.title3)
                                
                                Spacer()
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                    .labelStyle(.iconOnly)
                    .padding()

                    Button {
                        showNewIdentity = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 100)
                                .foregroundStyle(.thinMaterial)
                                .shadow(color: .black.opacity(0.1), radius: 10, y: 10)
                            
                            HStack {
                                Image(systemName: "person")
                                    .imageScale(.large)
                                    .foregroundStyle(.white)
                                    .padding()
                                    .background(Circle().foregroundColor(.accentColor))
                                
                                Text("Identity")
                                    .font(.title3)
                                
                                Spacer()
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                    .labelStyle(.iconOnly)
                    .padding()
                }
            }
            
            VStack {
                Spacer()
                
                Button {
                    withAnimation {
                        showDimmingAddScreen.toggle()
                    }
                } label: {
                    Label("Add", systemImage: "plus")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Circle().foregroundColor(.accentColor))
                        .rotationEffect(showDimmingAddScreen ? .degrees(45) : .degrees(0))
                }
                .labelStyle(.iconOnly)
                .padding()
                
//                Menu {
//                    Button {
//                        showNewCatalyst = true
//                    } label: {
//                        Image(systemName: "flask")
//                        Text("Catalyst")
//                    }
//                    
//                    Button {
//                        showNewIdentity = true
//                    } label: {
//                        Image(systemName: "person")
//                        Text("Identity")
//                    }
//                } label: {
//                    Label("Add", systemImage: "plus")
//                        .imageScale(.large)
//                        .foregroundStyle(.white)
//                        .padding()
//                        .background(Circle().foregroundColor(.accentColor))
//                }
//                .labelStyle(.iconOnly)
//                .padding()
            }
        }
        .hideNavBarOnSwipe(hideNavBarOnSwipe)
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
//        .alert("Edit Identity", isPresented: $renamingIdentity) { // Formerly "Rename Identity"
//            Button("OK", action: completeRename)
//            Button("Cancel", role: .cancel) { }
//            HStack {
//                SymbolPicker(symbol: $identityIcon)
//                TextField("Rename", text: $identityName)
//            }
//        }
        .sheet(isPresented: $renamingIdentity) {
            NavigationStack {
                NewIdentityView(identity: identityToRename)
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showNewCatalyst) {
            NavigationStack {
                NewCatalystView()
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showNewIdentity) {
            NavigationStack {
                NewIdentityView(identity: nil)
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
        renamingIdentity = true
    }
    
//    func completeRename() {
//        identityToRename?.name = identityName
//        identityToRename?.icon = identityIcon
//        dataController.save()
//    }
    
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
