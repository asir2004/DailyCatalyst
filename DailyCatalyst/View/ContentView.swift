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
        .toolbar(content: ContentViewToolbar.init)
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
