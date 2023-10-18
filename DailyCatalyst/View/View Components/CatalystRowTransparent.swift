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
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.thinMaterial)
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    if (catalyst.image != nil) {
                        if let image = UIImage(data: catalyst.image!) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .mask(RadialGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .black.opacity(0.5), location: 0),
                                        .init(color: .clear, location: 1)
                                    ]),
                                    center: .bottomTrailing,
                                    startRadius: 0,
                                    endRadius: 130
                                ))
                        }
                    } else {
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
            }
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(catalyst.catalystTitle)
                            .font(.title)
                        Text(catalyst.catalystEffect)
                            .font(.subheadline)
                        
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
            
            NavigationLink(value: catalyst) {
                Image(systemName: "folder")
            }
            .opacity(0)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(height: 150)
    }
}

#Preview {
    CatalystRowTransparent(catalyst: .example)
}
