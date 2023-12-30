//
//  ContentView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/1/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    @AppStorage("scrollViewEffect") var scrollViewEffect = true
    @AppStorage("hideNavBarOnSwipe") var hideNavBarOnSwipe = true
    
    @State private var isEditing = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            StaggeredGrid(columns: 2, list: dataController.catalystsForSelectedFilter(), content: { catalyst in
                @State var isSelected = false
                CatalystRowTransparent(catalyst: catalyst, width: size.width / 2, isEditing: isEditing, isSelected: $isSelected)
                    .if(scrollViewEffect) { view in
                        view.scrollTransition(axis: .vertical) { content, phase in
                            content
                                .scaleEffect(
                                    x: phase.isIdentity ? 1.0 : 0.8,
                                    y: phase.isIdentity ? 1.0 : 0.8
                                )
                                .blur(radius: phase.isIdentity ? 0 : 10)
                                .opacity(phase.isIdentity ? 1.0 : 0)
                                .offset(y: phase.isIdentity ? 0 : 50)
                        }
                    }
            })
            .safeAreaPadding(.horizontal)
        }
        .navigationTitle(dataController.selectedFilter?.name ?? "Catalysts")
//        .toolbar(content: ContentViewToolbar.init)
        .toolbar {
            Button {
                isEditing.toggle()
            } label: {
                Text(isEditing ? "Done" : "Edit")
            }
            
            Menu {
                Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                    dataController.filterEnabled.toggle()
                }

                Divider()

                Menu("Sort By") {
                    Picker("Sort By", selection: $dataController.sortType) {
                        Text("Date Created").tag(SortType.dateCreated)
                        Text("Date Modified").tag(SortType.dateModified)
                    }

                    Divider()

                    Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                        Text("Newest to Oldest").tag(true)
                        Text("Oldest to Newest").tag(false)
                    }
                }

                Picker("Status", selection: $dataController.filterStatus) {
                    Text("All").tag(Status.all)
                    Text("Open").tag(Status.open)
                    Text("Archived").tag(Status.archived)
                }
                .disabled(dataController.filterEnabled == false)

                Picker("Happiness", selection: $dataController.filterHappiness) {
                    Text("All").tag(-1)
                    Text("Exhausted").tag(1)
                    Text("Boring").tag(2)
                    Text("Apathetic").tag(3)
                    Text("Happy").tag(4)
                    Text("Joy").tag(5)
                }
                .disabled(dataController.filterEnabled == false)
            } label: {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    .symbolVariant(dataController.filterEnabled ? .fill : .none)
            }
        }
        .hideNavBarOnSwipe(hideNavBarOnSwipe)
    }
    
    func delete(_ offsets: IndexSet) {
        let catalysts = dataController.catalystsForSelectedFilter()
        
        for offset in offsets {
            let item = catalysts[offset]
            dataController.delete(item)
        }
    }
}

#Preview {
    ContentView()
}
