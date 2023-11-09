//
//  BorderedText.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/9/23.
//

import SwiftUI

struct BorderedText: View {
    var text: String
    var color: Color
    var font: Font
    
    var body: some View {
        ZStack {
            Text(text)
                .font(font)
                .foregroundStyle(color)
                .padding(.vertical, 3)
                .padding(.horizontal, 6)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.clear)
                        .stroke(color, lineWidth: 1)
                )
        }
    }
}

#Preview {
    BorderedText(text: "Beta", color: .orange, font: .footnote)
}
