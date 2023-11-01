//
//  SettingsView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/26/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("colorScheme") var colorScheme = "system"
    @AppStorage("scrollViewEffect") var scrollViewEffect = true
    
    var body: some View {
        NavigationStack {
            List {
                Section("Visual Effects") {
                    VStack(alignment: .leading) {
                        Label("Color Scheme", systemImage: returnColorSchemeIcon())
                            .imageScale(.large)
                            .frame(height: 30)
                            .contentTransition(.symbolEffect(.replace.offUp))
                        
                        Picker("Color Scheme Picker", selection: $colorScheme) {
                            Text("System").tag("system")
                            Text("Light").tag("light")
                            Text("Dark").tag("dark")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    HStack {
                        Label("Scroll Effect", systemImage: returnScrollEffectIcon())
                            .imageScale(.large)
                            .frame(height: 30)
                            .contentTransition(.symbolEffect(.replace.offUp))
                        
                        Spacer()
                        
                        Toggle("Scroll Effect Toggle", isOn: $scrollViewEffect)
                            .labelsHidden()
                    }
                    .frame(height: 30)
                }
                
                Section {
                    
                }
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(returnColorScheme())
    }
    
    func returnScrollEffectIcon() -> String {
        switch scrollViewEffect {
        case true:
            return "square.stack.3d.up"
        case false:
            return "square.stack.3d.up.slash"
        }
    }
    
    func returnColorSchemeIcon() -> String {
        switch colorScheme {
        case "system":
            return "cloud.sun"
        case "light":
            return "sun.max"
        case "dark":
            return "moon"
        default:
            return "questionmark"
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

#Preview {
    SettingsView()
}
