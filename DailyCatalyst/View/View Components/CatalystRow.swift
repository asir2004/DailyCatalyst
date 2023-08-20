//
//  CatalystRow.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI

struct CatalystRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var catalyst: Catalyst
    
    var emoji: String {
        switch catalyst.happiness {
        case 1: return "😐"
        case 2: return "🙂"
        case 3: return "😀"
        case 4: return "😁"
        case 5: return "😆"
        default: return "🥲"
        }
    }
    
    var body: some View {
        NavigationLink(value: catalyst) {
            HStack {
//                Image(systemName: "iphone")
//                    .imageScale(.large)
//                    .opacity(Double(catalyst.happiness) * 0.2)
                ZStack {
                    Circle()
                        .foregroundStyle(.yellow)
                        .frame(width: 30)
                        .opacity(catalyst.happiness <= 1 ? 0 : 1)
                        .blur(radius: CGFloat(catalyst.happiness == 1 ? 0 : catalyst.happiness * 5))
                    
                    Text("\(emoji)")
                        .foregroundStyle(catalyst.catalystStatus == "archived" ? .primary : .secondary)
                        .font(.title)
                }
                
                VStack(alignment: .leading) {
                    Text(catalyst.catalystTitle)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(catalyst.catalystIdentitiesList)
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
