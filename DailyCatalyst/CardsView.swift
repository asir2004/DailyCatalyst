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
    
    @State private var isRotated = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(isRotated ? "Toggle Rotation: On" : "Off") {
                        isRotated.toggle()
                    }
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            ForEach(dataController.catalystsForSelectedFilter().indices.prefix(5)) { index in
                                SummarizePageOneCard(catalyst: dataController.catalystsForSelectedFilter()[index])
                                    .rotationEffect(Angle(degrees: (isRotated ? -30 : 0) + (isRotated ? 15 : 0) * Double(index)), anchor: .bottom)
                                    .scaleEffect(0.65)
                                    .animation(.spring(.bouncy(duration: 0.5, extraBounce: 0.15), blendDuration: 3), value: isRotated)
                            }
                        }
                        
                        Spacer()
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
        .onAppear() {
            withAnimation {
                isRotated = true
            }
        }
        .navigationTitle("Summarize by AI")
    }
}

#Preview {
    CardsView()
}
