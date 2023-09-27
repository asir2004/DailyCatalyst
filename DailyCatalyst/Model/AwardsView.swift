//
//  AwardsView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 9/27/23.
//

import SwiftUI

struct AwardsView: View {
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.secondary.opacity(0.5))
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Awards")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AwardsView()
}
