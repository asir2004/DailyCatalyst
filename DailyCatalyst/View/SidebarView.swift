//
//  SidebarView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilters: [Filter] = [.all, .recent]
    
    @State private var showNewCatalyst = false
    @State private var showNewTag = false
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.tagID , name: tag.tagName , icon: "tag", tag: tag)
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
            
            Section("Tags") {
                ForEach(tagFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                            .badge(filter.tag?.tagActiveCatalysts.count ?? 0)
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
        .sheet(isPresented: $showNewTag) {
            NavigationStack {
                NewTagView()
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
                    showNewTag = true
                } label: {
                    Image(systemName: "tag")
                    Text("Tag")
                }
            }
        }
    }
    
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .environmentObject(DataController.preview)
    }
}
