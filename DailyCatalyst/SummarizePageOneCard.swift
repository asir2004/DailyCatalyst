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
            
            Text(emojiFromHappiness(happiness: Int(catalyst.happiness)))
                .font(.system(size: 200))
                .offset(y: 125)
                .opacity(0.15)
                .blur(radius: 10)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(width: 250, height: 350)
    }
}

#Preview {
    SummarizePageOneCard(catalyst: .example)
}
