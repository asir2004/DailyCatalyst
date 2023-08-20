//
//  ContentView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/1/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        List(selection: $dataController.selectedCatalyst) {
            ForEach(dataController.catalystsForSelectedFilter()) { catalyst in
                CatalystRow(catalyst: catalyst)
                    .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                        Button {
                            catalyst.archived.toggle()
                        } label: {
                            Label(catalyst.archived ? "Mark Open" : "Archive", systemImage: catalyst.archived ? "envelope.open" : "envelope")
                                .tint(catalyst.archived ? .blue : .red)
                        }
                    })
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(dataController.selectedFilter?.name ?? "Catalysts")
        .searchable(text: $dataController.filterText, tokens: $dataController.filterTokens, suggestedTokens: .constant(dataController.suggestedFilterTokens), prompt: "Search… or type # to add tags") { tag in
            Text(tag.tagName)
        }
        .toolbar {
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
    }
    
    func delete(_ offsets: IndexSet) {
        let catalysts = dataController.catalystsForSelectedFilter()
        
        for offset in offsets {
            let item = catalysts[offset]
            dataController.delete(item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
