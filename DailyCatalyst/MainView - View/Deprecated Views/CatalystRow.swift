//
//  CatalystRow.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI

struct CatalystRow: View {
    var catalyst: Catalyst
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundStyle(.yellow)
                    .frame(width: 30)
                    .opacity(catalyst.happiness <= 1 ? 0 : 1)
                    .blur(radius: CGFloat(catalyst.happiness == 1 ? 0 : catalyst.happiness * 5))
                
                if (catalyst.image != nil) {
                    if let image = UIImage(data: catalyst.image!) {
                        Image(uiImage: image)
                            .resizable()
                            .blur(radius: 1)
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    } else {
                        Text("\(emojiFromHappiness(happiness: Int(catalyst.happiness)))")
                            .foregroundStyle(catalyst.catalystStatus == "archived" ? .primary : .secondary)
                            .font(.title)
                            .frame(width: 30, height: 30)
                    }
                } else {
                    Text("\(emojiFromHappiness(happiness: Int(catalyst.happiness)))")
                        .foregroundStyle(catalyst.catalystStatus == "archived" ? .primary : .secondary)
                        .font(.title)
                        .frame(width: 30, height: 30)
                }
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
                Text(catalyst.catalystCreationDateFormatted)
                    .accessibilityLabel(catalyst.catalystCreationDate.formatted(date: .abbreviated, time: .omitted))
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

#Preview {
    CatalystRow(catalyst: .example)
}
