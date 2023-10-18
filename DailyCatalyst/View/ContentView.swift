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
        ScrollView(.vertical) {
            ForEach(dataController.catalystsForSelectedFilter()) { catalyst in
                CatalystRowTransparent(catalyst: catalyst)
                    .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                        Button {
                            catalyst.archived.toggle()
                        } label: {
                            Label(catalyst.archived ? "Mark Open" : "Archive", systemImage: catalyst.archived ? "envelope.open" : "envelope")
                                .tint(catalyst.archived ? .blue : .red)
                        }
                    })
                    .scrollTransition(axis: .vertical) { content, phase in
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
            .onDelete(perform: delete)
            .scrollTargetLayout()
            .safeAreaPadding()
        }
        .scrollTargetBehavior(.viewAligned)
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

#Preview {
    ContentView()
}
