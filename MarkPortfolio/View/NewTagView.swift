//
//  NewTagView.swift
//  MarkPortfolio
//
//  Created by Asir Bygud on 8/6/23.
//

import SwiftUI

struct NewTagView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var newTagName = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Tag Name", text: $newTagName, prompt: Text("Enter Tag Name Here"))
                    
                    Spacer()
                    
                    Button("Save") {
                        save()
                    }
                }
            }
            Section("Tags") {
                // Tags Shown Here.
            }
        }
        .navigationTitle("New Tag")
        .toolbar {
            Button("Done") {
                dismiss()
            }
        }
    }
    
    private func save() {
        let newTag = Tag(context: viewContext)
        newTag.name = newTagName
        
        try? viewContext.save()
    }
}

#Preview {
    NewTagView()
}
