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
    @AppStorage("accentColor") var accentColor: Color = .accentColor
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MainView()
                    .tabItem {
                        Label("Catalysts", systemImage: "flask")
                    }
                CardsView()
                    .tabItem {
                        Label("Cards", systemImage: "rectangle.on.rectangle")
                    }
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
//            .modelContainer(for: Catalyst.self)
            .preferredColorScheme(returnColorScheme())
            .accentColor(accentColor)
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

#Preview {
    TabView {
        Text("Main View")
            .tabItem {
                Label("Catalysts", systemImage: "flask")
            }
        CardsView(isPreview: true)
            .tabItem {
                Label("Cards", systemImage: "rectangle.on.rectangle")
            }
    }
}
