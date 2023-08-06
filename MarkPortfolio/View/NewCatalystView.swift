//
//  NewCatalystView.swift
//  MarkPortfolio
//
//  Created by Asir Bygud on 8/5/23.
//

import SwiftUI

// IT CAN'T WORK!!! LLDB THINGS…

struct happiness: Hashable {
    var level: Int
    var emoji: String
}

struct NewCatalystView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    let happinessLevels = [
        happiness(level: 1, emoji: "🥲"),
        happiness(level: 2, emoji: "😐"),
        happiness(level: 3, emoji: "🙂"),
        happiness(level: 4, emoji: "😀"),
        happiness(level: 5, emoji: "😆")
    ]
    
    @State private var newCatalystTitle = ""
    @State private var newCatalystEffect = ""
    @State private var newCatalystDate: Date = .now
    @State private var newCatalystHappiness = 3
    @State private var newCatalystTag: [Tag]?
    
    var body: some View {
        List {
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
        newCatalyst.modificationDate = .now
        newCatalyst.happiness = Int16(newCatalystHappiness)
        newCatalyst.archived = false
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Failed to save Core Data changes: \(nsError.localizedDescription)")
        }
        dismiss()
    }
}

#Preview {
    NewCatalystView()
}
