//
//  CatalystRowTransparent.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/18/23.
//

import SwiftUI

struct CatalystRowTransparent: View {
    @ObservedObject var catalyst: Catalyst
    
    var body: some View {
        NavigationLink(destination: CatalystView(catalyst: catalyst)) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.thinMaterial)
                    
                if (catalyst.image != nil) {
                    if let image = UIImage(data: catalyst.image!) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 200)
                            .mask(RadialGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .black.opacity(0.5), location: 0),
                                    .init(color: .clear, location: 1)
                                ]),
                                center: .bottomTrailing,
                                startRadius: 0,
                                endRadius: 150
                            ))
                            
                            .frame(alignment: .bottomTrailing)
                    }
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        Text(emojiFromHappiness(happiness: Int(catalyst.happiness)))
                            .font(.system(size: 100))
                            .mask(LinearGradient(gradient: Gradient(stops: [
                                .init(color: .black.opacity(0.2), location: 0),
                                .init(color: .clear, location: 1),
                                .init(color: .black, location: 1),
                                .init(color: .clear, location: 1)
                            ]), startPoint: .trailing, endPoint: .leading))
                    }
                }
                
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(catalyst.catalystTitle)
                                .font(.title)
                                .lineLimit(2)
                            Text(catalyst.catalystEffect)
                                .font(.subheadline)
                                .lineLimit(2)
                            
                            Spacer()
                            
                            Text(catalyst.catalystHappeningDate.formatted(date: .numeric, time: .omitted))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .frame(height: catalyst.image != nil ? 200 : 150)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CatalystRowTransparent(catalyst: .example)
}
