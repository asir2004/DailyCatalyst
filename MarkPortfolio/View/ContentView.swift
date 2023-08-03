//
//  ContentView.swift
//  MarkPortfolio
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
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Catalysts")
        .searchable(text: $dataController.filterText, prompt: Text("Search…"))
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
