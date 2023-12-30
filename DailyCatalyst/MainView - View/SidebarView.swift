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
    @AppStorage("isSystemColorScheme") var isSystemColorScheme = true
    @AppStorage("toggleDarkMode") var toggleDarkMode: Bool = false
    @AppStorage("activateDarkMode") var activateDarkMode: Bool = false
    
    @AppStorage("useLayersAddScreen") var useLayersAddScreen: Bool = false
    
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
    @State private var showAddScreenLayer = false
    
    @State private var currentImage: UIImage?
    @State private var previousImage: UIImage?
    @State private var maskAnimation: Bool = false
    @State private var buttonRect: CGRect = .zero
    
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
                
//                Section("Test") {
//                    CatalystRowTransparent(catalyst: Catalyst.example, width: 400, isEditing: false, isSelected: Binding.constant(false))
//                }
            }
            
            if useLayersAddScreen {
                if showAddScreenLayer {
                    Color(.black.opacity(0.25))
                        .ignoresSafeArea()
                        
                    AddScreenLayer()
                        .frame(height: 400)
                        .offset(y: -100)
                }
            } else {
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
                                        .font(.title2)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                        }
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
                                        .font(.title2)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                        }
                        //                    .labelStyle(.iconOnly)
                        .padding()
                    }
                }
            }
            
            VStack {
                Spacer()
                
                Button {
                    withAnimation {
                        if useLayersAddScreen {
                            showAddScreenLayer.toggle()
                        } else {
                            showDimmingAddScreen.toggle()
                        }
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
        // MARK: -Dark Mode Switch
        .createImages(
            toggleDarkMode: toggleDarkMode,
            currentImage: $currentImage,
            previousImage: $previousImage,
            activateDarkMode: $activateDarkMode
        )
        .overlay(content: {
            GeometryReader { geometry in
                let size = geometry.size
                
                if let previousImage, let currentImage {
                    ZStack {
                        Image(uiImage: previousImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                        
                        Image(uiImage: currentImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width, height: size.height)
                            .mask(alignment: .topLeading) {
                                Circle()
                                    .frame(width: buttonRect.width * (maskAnimation ? 80 : 1), height: buttonRect.height * (maskAnimation ? 80 : 1), alignment: .topLeading)
                                    .frame(width: buttonRect.width, height: buttonRect.height)
                                    .offset(x: -buttonRect.minX, y: buttonRect.minY)
                                    .ignoresSafeArea()
                            }
                    }
                    .task {
                        guard !maskAnimation else { return }
                        withAnimation(.easeInOut(duration: 0.9), completionCriteria: .logicallyComplete) {
                            maskAnimation = true
                        } completion: {
                            self.currentImage = nil
                            self.previousImage = nil
                            maskAnimation = false
                        }
                    }
                }
            }
            /// Reverse masking
            .mask {
                Rectangle()
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .frame(width: buttonRect.width, height: buttonRect.height)
                            .offset(x: buttonRect.minX, y: buttonRect.minY)
                            .blendMode(.destinationOut)
                    }
            }
            .ignoresSafeArea()
        })
        .if(!isSystemColorScheme) { view in
            view
                .overlay(alignment: .bottomLeading) {
                    Button {
                        toggleDarkMode.toggle()
                    } label: {
                        Image(systemName: toggleDarkMode ? "sun.min.fill" : "moon.fill")
                            .font(.title2)
                            .foregroundStyle(Color.primary)
                            .symbolEffect(.bounce, value: toggleDarkMode)
                            .frame(width: 40, height: 40)
                    }
                    .padding(10)
                    .rect { rect in
                        buttonRect = rect
                    }
                    .disabled(currentImage != nil || previousImage != nil || maskAnimation)
                }
                .preferredColorScheme(activateDarkMode ? .dark : .light)
        }
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
