//
//  CardsView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 11/25/23.
//

import SwiftUI
import GoogleGenerativeAI
import CoreData
import OSLog

struct CardsView: View {
    private var logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "generative-ai")
    let model = GenerativeModel(name: "gemini-pro", apiKey: "AIzaSyDpW5cnlKt8wLfmOrgevh8L0x_0Q4JFxms")
    @EnvironmentObject var dataController: DataController
    
    @State private var summarizePrompt = "这是我最近做的事情, 请你给我一点总结和激励: "
    @State private var summarizeOutput = "Summary"
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            ForEach(dataController.catalystsForSelectedFilter().indices.suffix(5)) { index in
                                SummarizePageOneCard(catalyst: dataController.catalystsForSelectedFilter()[index])
                                    .rotationEffect(Angle(degrees: (isLoading ? 0 : -45) + (isLoading ? 0 : 15) * Double(index)), anchor: .bottom)
                                    .scaleEffect(0.65)
                                    .animation(.spring(.bouncy(duration: 0.5, extraBounce: 0.15), blendDuration: 3), value: isLoading)
                            }
                        }
                        .offset(y: isLoading ? 0 : -10)
                        
                        Spacer()
                    }
                    .frame(height: 300)
                }
                
                Section("Summarize") {
                    Button {
                        Task {
                            await summarize()
                        }
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .padding(.trailing)
                            } else {
                                Image(systemName: "square.and.pencil")
                                    .padding(.trailing)
                            }
                            
                            Text(isLoading ? "Loading…" : "Summarize my Catalysts")
                        }
                    }
                    .disabled(isLoading)
                    
                    Text(.init(summarizeOutput))
                        .foregroundStyle((summarizeOutput == "Summary" || isLoading) ? .secondary : .primary)
                }
            }
            .navigationTitle("Summarize by AI")
        }
    }
    
    func summarize() async {
        defer {
            isLoading = false
        }
        
        do {
            errorMessage = nil
            isLoading = true
            
            summarizePrompt = "这是我最近做的事情, 请你给我一点总结和激励: "
            
            for catalyst in dataController.catalystsForSelectedFilter() {
                summarizePrompt += catalyst.catalystTitle
                summarizePrompt += ", "
            }
            
            let response = try await model.generateContent(summarizePrompt)
            
            if let text = response.text {
                summarizeOutput = text
            }
        } catch {
            logger.error("\(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    CardsView()
}
