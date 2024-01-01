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
    
    var isPreview = false
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var summarizePrompt = "这是我最近做的事情, 请你给我一点总结和激励: "
    @State private var summarizeOutput = "Summary"
    
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var showAlert = false
    @State private var selectedSummary: SummaryOutput?
    
//    let exampleCatalysts: [Catalyst] = [.example, .example2, .example, .example, .example]
//    let exampleSummaries: [SummaryOutput] = [.example, .example2]
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.creationDate, order: .reverse)]) private var summaries: FetchedResults<SummaryOutput>
    
//    let summaries = NSFetchRequest<SummaryOutput>(entityName: "SummaryOutput")
    
    init(isPreview: Bool = false) {
        self.isPreview = isPreview
    }
    
    var hMargin: CGFloat {
        #if os(macOS)
        40.0
        #else
        20.0
        #endif
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    HStack {
                        List {
                            Section {
                                HStack {
                                    Spacer()
                                    
                                    ZStack {
                                        ForEach(dataController.catalystsForSelectedFilter().indices.prefix(5)) { index in
                                            SummarizePageOneCard(catalyst: dataController.catalystsForSelectedFilter()[index])
                                                .rotationEffect(Angle(degrees: (isLoading ? 0 : -30) + (isLoading ? 0 : 15) * Double(index)), anchor: .bottom)
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
                                                .padding(.trailing, 3)
                                        } else {
                                            Image(systemName: "square.and.pencil")
                                                .padding(.trailing, 3)
                                        }
                                        
                                        Text(isLoading ? "Loading…" : "Summarize my Catalysts")
                                    }
                                }
                                .disabled(isLoading)
                                
                                Text(.init(summarizeOutput))
                                    .foregroundStyle((summarizeOutput == "Summary" || isLoading) ? .secondary : .primary)
                            }
                        }
                        .frame(width: max(geometry.size.width - 40, 0), height: max(geometry.size.height - 40, 0))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        List {
                            Section("History") {
                                ForEach(summaries, id: \.self) { summary in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(summary.summaryCreationDate.formatted())
                                                .foregroundStyle(.secondary)
                                                .padding(.bottom)
                                            
                                            Spacer()
                                            
                                            Button(role: .destructive) {
                                                showAlert.toggle()
                                                selectedSummary = summary
                                            } label: {
                                                Text("Remove")
                                            }
                                            .buttonStyle(.bordered)
                                        }
                                        
                                        Text(.init(summary.summaryDetail))
                                    }
                                }
                            }
                        }
                        .frame(width: max(geometry.size.width - 40, 0), height: max(geometry.size.height - 40, 0))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, hMargin)
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.never)
            }
            .navigationTitle("Summarize by AI")
        }
        .alert("Delete Summary?", isPresented: $showAlert) {
            Button("Remove", role: .destructive) {
                viewContext.delete(selectedSummary!)
                showAlert.toggle()
            }
            
            Button("Cancel", role: .cancel) { }
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
                
                let newSummary = SummaryOutput(context: viewContext)
                newSummary.detail = text
                newSummary.creationDate = .now
                
                try? viewContext.save()
            }
        } catch {
            logger.error("\(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }
    
    func onDelete(at offsets: IndexSet) {
        for index in offsets {
            let summary = summaries[index]
            viewContext.delete(summary)
        }
    }
}

#Preview {
    CardsView(isPreview: true)
}
