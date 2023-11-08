//
//  DailyCatalystApp.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 8/1/23.
//

import SwiftUI
import TipKit

@main
struct DailyCatalystApp: App {
    @StateObject var dataController = DataController()
    @Environment(\.scenePhase) var scenePhase
    
    @AppStorage("isSystemColorScheme") var isSystemColorScheme = true
    @AppStorage("activateDarkMode") var activateDarkMode: Bool = false
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                let size = geometry.size
                NavigationSplitView {
                    SidebarView()
                } content: {
                    ContentView()
                } detail: {
                    DetailView()
                }
                .navigationSplitViewColumnWidth(ideal: size.width / 2)
            }
            .task {
                try? Tips.configure([
                    .displayFrequency(.monthly),
                    .datastoreLocation(.applicationDefault)
                ])
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
            .onChange(of: scenePhase) {
                if scenePhase != .active {
                    dataController.save()
                }
            }
            .preferredColorScheme(returnColorScheme())
        }
    }
    
    func returnColorScheme() -> ColorScheme? {
        if isSystemColorScheme {
            return .none
        } else {
            return activateDarkMode ? .dark : .light
        }
    }
}
