//
//  ContentViewToolbar.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/10/23.
//

import SwiftUI

struct ContentViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
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

#Preview {
    ContentViewToolbar()
}
