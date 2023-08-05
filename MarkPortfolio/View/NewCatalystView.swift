//
//  NewCatalystView.swift
//  MarkPortfolio
//
//  Created by Asir Bygud on 8/5/23.
//

import SwiftUI

struct NewCatalystView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var catalyst: Catalyst
    
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    NewCatalystView(catalyst: .example)
}
