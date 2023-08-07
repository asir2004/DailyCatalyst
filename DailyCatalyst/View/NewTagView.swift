//
//  NewTagView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/6/23.
//

import SwiftUI

struct NewTagView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var dataController: DataController
    
    @State private var newTagName = ""
    
    var body: some View {
        List {
            Section {
                HStack {
                    HStack {
                        Image(systemName: "tag")
                        TextField("Tag Name", text: $newTagName, prompt: Text("Enter Tag Name Here"))
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        save()
                        newTagName = ""
                    }
                }
            }
            Section("Tags") {
                ForEach(dataController.allTags()) { tag in
                    Text("\(tag.tagName)")
                }
                .onDelete(perform: delete)
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
        withAnimation {
            let newTag = Tag(context: viewContext)
            newTag.name = newTagName
            
            try? viewContext.save()
        }
    }
    
    private func delete(_ offsets: IndexSet) {
        let tags = dataController.allTags()
        
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
}

#Preview {
    NewTagView()
}
