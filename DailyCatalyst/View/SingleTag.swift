//
//  SingleTag.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/18/23.
//

import SwiftUI

struct SingleTag: View {
    var tag: Tag
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .tint(.blue)
                .foregroundStyle(.thinMaterial)
            Text(tag.tagName)
        }
    }
}

#Preview {
    SingleTag(tag: Tag.example)
}
