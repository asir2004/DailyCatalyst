//
//  CatalystRow.swift
//  MarkPortfolio
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI

struct CatalystRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var catalyst: Catalyst
    
    var body: some View {
        NavigationLink(value: catalyst) {
            HStack {
                Image(systemName: "iphone")
                    .imageScale(.large)
                    .opacity(Double(catalyst.happiness) * 0.2)
                
                VStack(alignment: .leading) {
                    Text(catalyst.catalystTitle)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(catalyst.catalystTagsList)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(catalyst.catalystCreationDate.formatted(date: .numeric, time: .omitted))
                        .font(.subheadline)
                    
                    if catalyst.archived {
                        Text("ARCHIVED")
                            .font(.body.smallCaps())
                    }
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}

struct CatalystRow_Previews: PreviewProvider {
    static var previews: some View {
        CatalystRow(catalyst: .example)
    }
}
