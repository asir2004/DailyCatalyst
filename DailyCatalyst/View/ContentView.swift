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
        GeometryReader {
            let size = $0.size
            StaggeredGrid(columns: 2, list: dataController.catalystsForSelectedFilter(), content: { catalyst in
                CatalystRowTransparent(catalyst: catalyst, width: size.width / 2)
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
                    
            })
            .safeAreaPadding(.horizontal)
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

#Preview {
    ContentView()
}
