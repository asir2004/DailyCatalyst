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
        VStack {
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
//                Section("Tags") {
//                    ScrollView(.horizontal) {
//                        LazyHStack(spacing: 5) {
//                            ForEach(dataController.allTags(), id: \.self) { tag in
//                                Text("\(tag.tagName)")
//                                    .foregroundStyle(.white)
//                                    .padding(5)
//                                    .background(.blue)
//                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                            }
//                        }
//                    }
//                    //                .onDelete(perform: delete)
//                }
            }
            GeometryReader { geo in
                let cardHeight: CGFloat? = geo.size.height > 0 ? (max(geo.size.height * 0.7, 240) - 40) : nil
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.ultraThinMaterial)
                    HStack {
                        ForEach(dataController.allTags(), id: \.self) { tag in
                            SingleTag(tag: tag)
                        }
                    }
                }
                .padding()
                .frame(maxHeight: cardHeight)
            }
        }
        .navigationTitle("New Tag")
        .navigationBarTitleDisplayMode(.inline)
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

struct NewTagView_Previews: PreviewProvider {
    static var previews: some View {
        NewTagView()
    }
}
