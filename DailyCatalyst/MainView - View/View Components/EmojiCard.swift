//
//  EmojiCard.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/19/23.
//

import SwiftUI

struct EmojiCard: View {
    var happiness: Int
    
    var emoji: String {
        switch happiness {
        case 1: return "😐"
        case 2: return "🙂"
        case 3: return "😀"
        case 4: return "😁"
        case 5: return "😆"
        default: return "🥲"
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(happiness == 1 ? .white : .yellow)
                    .foregroundStyle( .ultraThinMaterial)
                    .opacity(Double(happiness) * 0.05)
                    .frame(width: geo.size.width)
                    .padding(20)
                
                Text("\(emoji)")
                    .font(.title)
            }
        }
        .frame(maxHeight: 100)
    }
}

#Preview {
    EmojiCard(happiness: 3)
}
