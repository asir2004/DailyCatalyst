//
//  NoCatalystView.swift
//  MarkPortfolio
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI

struct NoCatalystView: View {
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        VStack {
            Text("No Catalyst Selected")
                .font(.title)
                .foregroundStyle(.secondary)
            Button {
                // Create New One View
            } label: {
                Text("Create New")
            }
        }
    }
}

struct NoCatalystView_Previews: PreviewProvider {
    static var previews: some View {
        NoCatalystView()
    }
}
