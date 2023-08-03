//
//  CatalystView.swift
//  MarkPortfolio
//
//  Created by Asir Bygud on 8/3/23.
//

import SwiftUI

struct CatalystView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var catalyst: Catalyst
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    TextField("Title", text: $catalyst.catalystTitle, prompt: Text("Enter Title Here"))
                        .font(.title)
                    
                    Text("**Modification Date:** \(catalyst.catalystModificationDate.formatted(date: .long, time: .shortened))")
                        .foregroundStyle(.secondary)
                    
                    Text("**Status:** \(catalyst.catalystStatus)")
                        .foregroundStyle(.secondary)
                }
                
                Picker("Happiness", selection: $catalyst.happiness) {
                    Text("Joy").tag(Int16(5))
                    Text("Happy").tag(Int16(4))
                    Text("Apathetic").tag(Int16(3))
                    Text("Boring").tag(Int16(2))
                    Text("Exhausted").tag(Int16(1))
                }
                
                Menu {
                    ForEach(catalyst.catalystTags) { tag in
                        Button {
                            catalyst.removeFromTags(tag)
                        } label: {
                            Label(tag.tagName, systemImage: "checkmark")
                        }
                    }
                    
                    let otherTags = dataController.missingTags(from: catalyst)
                    
                    if otherTags.isEmpty == false {
                        Divider()
                        
                        Section("Add Tags") {
                            ForEach(otherTags) { tag in
                                Button(tag.tagName) {
                                    catalyst.addToTags(tag)
                                }
                            }
                        }
                    }
                } label: {
                    Text(catalyst.catalystTagsList)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(nil, value: catalyst.catalystTagsList)
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Basic Info")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    TextField("Description", text: $catalyst.catalystEffect, prompt: Text("Enter the effect here"), axis: .vertical)
                }
            }
        }
        .disabled(catalyst.isDeleted)
        .onReceive(catalyst.objectWillChange) { _ in
            dataController.queueSave()
        }
    }
}

struct CatalystView_Previews: PreviewProvider {
    static var previews: some View {
        CatalystView(catalyst: .example)
    }
}
