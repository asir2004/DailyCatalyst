//
//  SummarizePageOneCard.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 12/30/23.
//

import SwiftUI

struct SummarizePageOneCard: View {
    @ObservedObject var catalyst: Catalyst
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.ultraThinMaterial)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(catalyst.catalystTitle)
                        .font(.title)
                    Text(catalyst.catalystEffect)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Text(catalyst.catalystHappeningDate.formatted())
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
            if (catalyst.image != nil) {
                if let image = UIImage(data: catalyst.image!) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 250, maxHeight: 350)
                        .clipped()
                        .mask(RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: .black.opacity(0.5), location: 0),
                                .init(color: .clear, location: 1)
                            ]),
                            center: .bottomTrailing,
                            startRadius: 0,
                            endRadius: min(image.size.height, 430)
                        ))
                        .frame(alignment: .bottomTrailing)
                        .ignoresSafeArea()
                }
            } else {
                Text(emojiFromHappiness(happiness: Int(catalyst.happiness)))
                    .font(.system(size: 200))
                    .offset(y: 125)
                    .opacity(0.15)
                    .blur(radius: 10)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(width: 250, height: 350)
    }
}

#Preview {
    SummarizePageOneCard(catalyst: .example)
}
