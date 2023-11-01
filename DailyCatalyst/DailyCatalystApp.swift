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
    @AppStorage("colorScheme") private var colorScheme = "system"
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                SidebarView()
            } content: {
                ContentView()
            } detail: {
                DetailView()
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
        switch colorScheme {
        case "system":
            return .none
        case "light":
            return .light
        case "dark":
            return .dark
        default:
            return .none
        }
    }
}
