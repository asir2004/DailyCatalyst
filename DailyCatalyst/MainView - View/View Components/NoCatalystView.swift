//
//  NoCatalystView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI

struct NoCatalystView: View {
    @EnvironmentObject var dataController: DataController
    @State private var showNewCatalyst = false
    
    var body: some View {
        VStack {
            Text("No Catalyst Selected")
                .font(.title)
                .foregroundStyle(.secondary)
            Button {
                showNewCatalyst = true
            } label: {
                Text("Create New")
            }
        }
        .sheet(isPresented: $showNewCatalyst) {
            NavigationStack {
                NewCatalystView()
            }
        }
    }
}

#Preview {
    NoCatalystView()
}
