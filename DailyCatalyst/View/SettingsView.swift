//
//  SettingsView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/26/23.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("colorScheme") var colorScheme = "system"
    @AppStorage("scrollViewEffect") var scrollViewEffect = true
    
    @Environment(\.dismiss) var dismiss
    
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
                
                Section("Notifications") {
                    Button {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    } label: {
                        Label("Request Notification Permission", systemImage: "bell")
                            .imageScale(.large)
                            .frame(height: 30)
                    }
                    
                    Button {
                        let content = UNMutableNotificationContent()
                        content.title = "Feed the cat"
                        content.subtitle = "It looks hungry"
                        content.sound = UNNotificationSound.default

                        // show this notification five seconds from now
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                        // choose a random identifier
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                    } label: {
                        Label("Schedule Notification", systemImage: "bell.and.waves.left.and.right")
                            .imageScale(.large)
                            .frame(height: 30)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
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
}

#Preview {
    SettingsView()
}
