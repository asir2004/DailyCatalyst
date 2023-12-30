//
//  CardsView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/25/23.
//

import SwiftUI
import GoogleGenerativeAI
import CoreData

struct CardsView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: "AIzaSyDpW5cnlKt8wLfmOrgevh8L0x_0Q4JFxms")
    @EnvironmentObject var dataController: DataController
    
    @State private var inputText = ""
    @State private var outputText = "Hello, World!"
    
    @State private var summarizePrompt = "这是我最近做的事情, 请你给我一点总结和激励: "
    @State private var summarizeOutput = "Summary"
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(dataController.catalystsForSelectedFilter()) { catalyst in
                        SummarizePageOneCard(catalyst: catalyst)
                    }
                }
                
                Section("Talk") {
                    TextField("Input Text", text: $inputText)
                    
                    Button("Send") {
                        Task {
                            let response = try await model.generateContent(inputText)
                            if let text = response.text {
                                outputText = text
                            }
                        }
                    }
                    
                    Text(.init(outputText))
                }
                
                Section("Summarize") {
                    Button("Summarize my Catalysts") {
                        summarizePrompt = "这是我最近做的事情, 请你给我一点总结和激励: "
                        
                        for catalyst in dataController.catalystsForSelectedFilter() {
                            summarizePrompt += catalyst.catalystTitle
                            summarizePrompt += ", "
                        }
                        
                        Task {
                            let response = try await model.generateContent(summarizePrompt)
                            if let text = response.text {
                                summarizeOutput = text
                            }
                        }
                    }
                    
                    Text(.init(summarizeOutput))
                }
            }
        }
        .navigationTitle("Summarize by AI")
    }
}

#Preview {
    CardsView()
}
