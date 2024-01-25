//
//  TestWrappedHStackView.swift
//  LearnGrid
//
//  Created by Mohammad Azam on 9/5/21.
//

import SwiftUI

struct TagsView: View {
    
    let entities: [Identity]
    
    var items: [String]
    var groupedItems: [[String]] = [[String]]()
    #if os(iOS)
    let screenWidth = UIScreen.main.bounds.width
    #endif
    
    init(entities: [Identity], items: [String]) {
        self.entities = entities
        self.items = entities.map { $0.name ?? "" }
        self.groupedItems = createGroupedItems(items)
    }
    
    private func createGroupedItems(_ items: [String]) -> [[String]] {
        
        var groupedItems: [[String]] = [[String]]()
        var tempItems: [String] =  [String]()
        var width: CGFloat = 0
        
        for word in items {
            
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 32
            
            if (width + labelWidth + 55) < screenWidth {
                width += labelWidth
                tempItems.append(word)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(word)
            }
            
        }
        
        groupedItems.append(tempItems)
        return groupedItems
        
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                ForEach(groupedItems, id: \.self) { subItems in
                    HStack {
                        ForEach(subItems, id: \.self) { word in
                            Text(word)
                                .fixedSize()
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}
