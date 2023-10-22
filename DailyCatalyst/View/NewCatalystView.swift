//
//  NewCatalystView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/5/23.
//

import SwiftUI

struct happiness: Hashable {
    var level: Int
    var emoji: String
}

struct NewCatalystView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    let happinessLevels = [
        happiness(level: 1, emoji: "😐"),
        happiness(level: 2, emoji: "🙂"),
        happiness(level: 3, emoji: "😀"),
        happiness(level: 4, emoji: "😁"),
        happiness(level: 5, emoji: "😆")
    ]
    
    @State private var newCatalystTitle = ""
    @State private var newCatalystEffect = ""
    @State private var newCatalystDate: Date = .now
    @State private var newCatalystHappiness = 3
    @State private var newCatalystIdentities: [Identity]?
    
    var newCatalystIdentitiesList: String {
        if let newCatalystIdentities {
            if newCatalystIdentities.count == 0 {
                return "No Identities"
            } else {
                return newCatalystIdentities.map(\.identityName).formatted()
            }
        } else {
            return "No Identities"
        }
    }
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var identities: FetchedResults<Identity>
    
    var body: some View {
        List {
//            // Fix this
//            EmptyImagePicker(catalyst: <#Catalyst#>, title: "Image", subTitle: "Tap to insert image", systemImage: "square.and.arrow.up", tint: .yellow, isEditing: true) { image in
//                print(image)
//            }
            
            Section("Add New Catalyst") {
                VStack(alignment: .leading) {
                    TextField("Title", text: $newCatalystTitle, prompt: Text("Enter Title Here"))
                        .font(.title)
                    Text("Modification Date: \(Date.now.formatted(date: .numeric, time: .omitted))")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading) {
                    DatePicker("When Happened?", selection: $newCatalystDate, displayedComponents: .date)
                }
                
                Picker(selection: $newCatalystHappiness, label: Text("Happiness")) {
                    ForEach(happinessLevels, id: \.self) { happinessLevel in
                        ZStack {
                            Circle()
                                .foregroundStyle(.secondary)
                                .foregroundColor(.blue)
                                .opacity(newCatalystHappiness == happinessLevel.level ? 0.3 : 0)
                            Text("\(happinessLevel.emoji)")
                                .font(newCatalystHappiness == happinessLevel.level ? .title : .none)
                        }
                        .tag(happinessLevel.level)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Menu {
                    ForEach(identities) { identity in
                        Button {
                            if newCatalystIdentities != nil {
                                if newCatalystIdentities!.contains(identity) {
                                    if let index = newCatalystIdentities!.firstIndex(of: identity) {
                                        newCatalystIdentities!.remove(at: index)
                                    }
                                } else {
                                    newCatalystIdentities?
                                        .append(identity)
                                }
                            } else {
                                newCatalystIdentities = [identity]
                            }
                        } label: {
                            Text(identity.identityName)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: newCatalystIdentities?.count == 0 ? "person" : "person.fill")
                            .symbolEffect(.bounce.down, value: newCatalystIdentities?.count)
                        
                        Text(newCatalystIdentitiesList)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .animation(.snappy, value: newCatalystIdentitiesList)
                    }
                }
                
                VStack {
                    TextField("Effect", text: $newCatalystEffect, prompt: Text("Input Effect Here."))
                }
            }
        }
        .toolbar {
            Button("Done") {
                save()
            }
        }
    }
    
    private func save() {
        let newCatalyst = Catalyst(context: viewContext)
        
        newCatalyst.title = newCatalystTitle
        newCatalyst.effect = newCatalystEffect
        newCatalyst.happeningDate = newCatalystDate
        newCatalyst.creationDate = .now
        newCatalyst.happiness = Int16(newCatalystHappiness)
        newCatalyst.archived = false
        
        if let newCatalystIdentities {
            for identity in newCatalystIdentities {
                newCatalyst.addToIdentities(identity)
            }
        }
        
        try? viewContext.save()
        dismiss()
    }
}

