//
//  AwardsView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 9/27/23.
//

import SwiftUI

struct AwardsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        NavigationLink {
                            AnimatedAwardView(awardName: award.name, awardDescription: award.description, symbolName: award.image, status: dataController.hasEarned(award: award), color: Color(award.color))
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(dataController.hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5))
                                .padding()
                        }
                        .accessibilityLabel(dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked: \(award.name)")
                        .accessibilityHint(award.description)
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
