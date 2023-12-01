//
//  MainView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/25/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
                .navigationSplitViewColumnWidth(1000)
        } content: {
            ContentView()
                .navigationSplitViewColumnWidth(1000)
        } detail: {
            DetailView()
        }
    }
}

#Preview {
    MainView()
}
