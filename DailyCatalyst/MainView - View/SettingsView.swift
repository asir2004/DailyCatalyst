//
//  SettingsView.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/26/23.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("isSystemColorScheme") var isSystemColorScheme = true
    @AppStorage("scrollViewEffect") var scrollViewEffect = true
    @AppStorage("hideNavBarOnSwipe") var hideNavBarOnSwipe = true
    @AppStorage("cardPictureHeight") var cardWithPictureHeight = 200
    @AppStorage("cardPlainHeight") var cardPlainHeight = 150
    @AppStorage("notificationTimeHour") var notificationTimeHour = 20
    @AppStorage("notificationTimeMinute") var notificationTimeMinute = 0
    @AppStorage("useLayersAddScreen") var addScreenStyle: AddScreenStyle = .menu
    
    var addScreenStyleTitle: String {
        switch addScreenStyle {
        case .layers:
            "Layers"
        case .screen:
            "Screen"
        case .menu:
            "Menu"
        }
    }
    
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("toggleDarkMode") var toggleDarkMode: Bool = false
    @AppStorage("activateDarkMode") var activateDarkMode: Bool = false
    @AppStorage("accentColor") var accentColor: Color = .accentColor
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    VStack(alignment: .leading) {
                        Label("Color Palette", systemImage: "paintpalette")
                            .accentColor(accentColor)
                            .imageScale(.large)
                            .frame(height: 30)
                            .symbolEffect(.bounce, value: accentColor)
                        
                        Picker("Card with Picture Height", selection: $accentColor) {
                            Text("Default")
                                .tag(Color.accentColor)
                            Text("Blue Hour")
                                .tag(Color("Blue Hour"))
                            Text("Blanket")
                                .tag(Color("Blanket"))
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                    
                    HStack {
                        Label("Use System Color Scheme", systemImage: returnColorSchemeIcon())
                            .imageScale(.large)
                            .frame(height: 30)
                            .contentTransition(.symbolEffect(.replace.offUp))
                        
                        Spacer()
                        
                        Toggle("Use System Color Scheme", isOn: $isSystemColorScheme)
                            .labelsHidden()
                    }
                    .frame(height: 30)
                }
                
                Section("Visual Effects") {
                    HStack {
                        Label("Add Screen Style", systemImage: addScreenStyleImage())
                            .imageScale(.large)
                            .frame(height: 30)
                            .contentTransition(.symbolEffect(.replace.offUp))
                        
                        BorderedText(text: "Beta", color: .orange, font: .footnote)
                        
                        Spacer()
                        
                        Menu {
                            Picker("Add Screen Style", selection: $addScreenStyle) {
                                Label("Layers", systemImage: "rectangle.on.rectangle")
                                    .tag(AddScreenStyle.layers)
                                Label("Screen", systemImage: "rectangle.portrait")
                                    .tag(AddScreenStyle.screen)
                                Label("Menu", systemImage: "rectangle.split.1x2")
                                    .tag(AddScreenStyle.menu)
                            }
                        } label: {
                            HStack {
                                Text(addScreenStyleTitle)
                                Image(systemName: "chevron.up.chevron.down")
                            }
                        }
                        .foregroundStyle(.secondary)
                    }
                    .frame(height: 30)
                    
                    HStack {
                        Label("Scroll Effect", systemImage: returnScrollEffectIcon())
                            .imageScale(.large)
                            .frame(height: 30)
                            .contentTransition(.symbolEffect(.replace.offUp))
                        
                        BorderedText(text: "Buggy", color: .red, font: .footnote)
                        
                        Spacer()
                        
                        Toggle("Scroll Effect Toggle", isOn: $scrollViewEffect)
                            .labelsHidden()
                    }
                    .frame(height: 30)
                    
                    HStack {
                        Label("Hide Nav Bar On Swipe", systemImage: returnHideNavBarIcon())
                            .imageScale(.large)
                            .frame(height: 30)
                            .contentTransition(.symbolEffect(.replace.offUp))
                        
                        Spacer()
                        
                        Toggle("Hide Nav Bar On Swipe", isOn: $hideNavBarOnSwipe)
                            .labelsHidden()
                    }
                    .frame(height: 30)
                    
                    VStack(alignment: .leading) {
                        Label("Card with Picture Height", systemImage: "photo.on.rectangle")
                            .imageScale(.large)
                            .frame(height: 30)
                            .symbolEffect(.bounce, value: cardWithPictureHeight)
                        
                        Picker("Card with Picture Height", selection: $cardWithPictureHeight) {
                            Text("Low")
                                .tag(150)
                            Text("Mid")
                                .tag(200)
                            Text("High")
                                .tag(250)
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                    
                    VStack(alignment: .leading) {
                        Label("Plain Card Height", systemImage: "rectangle.on.rectangle")
                            .imageScale(.large)
                            .frame(height: 30)
                            .symbolEffect(.bounce, value: cardPlainHeight)
                        
                        Picker("Plain Card Height", selection: $cardPlainHeight) {
                            Text("Low")
                                .tag(130)
                            Text("Mid")
                                .tag(150)
                            Text("High")
                                .tag(200)
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
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
                
                Section("Testing") {
                    CatalystRow(catalyst: DataController().randomCatalyst())
                }
                
                Section("Quick Help") {
                    HStack {
                        Image(systemName: "heart.rectangle")
                            .frame(width: 30)
                            .foregroundStyle(.yellow)
                        
                        Text("This is an app you can store things that make you happy in different identities.")
                    }
                    
                    HStack {
                        Image(systemName: "person.2")
                            .frame(width: 30)
                            .foregroundStyle(.yellow)
                        
                        Text("For example, I, as a motion designer, have made the very first 3D animation few weeks ago. At the same time, as a iOS dev amateur, have made the Core Data model in this app work few days ago.")
                    }
                    
                    HStack {
                        Image(systemName: "star")
                            .frame(width: 30)
                            .foregroundStyle(.yellow)
                        
                        Text("I can mark pretty happy things as 4 or 5 stars, then they will be more bright in Catalyst (I call it so) list.")
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
        .accentColor(.accentColor)
    }
    
    func returnColorSchemeIcon() -> String {
        switch isSystemColorScheme {
        case true:
            return "circle.fill"
        case false:
            return "circle.slash.fill"
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
    
    func returnHideNavBarIcon() -> String {
        switch hideNavBarOnSwipe {
        case true:
            return "rectangle.and.arrow.up.right.and.arrow.down.left"
        case false:
            return "rectangle.and.arrow.up.right.and.arrow.down.left.slash"
        }
    }
    
    func addScreenStyleImage() -> String {
        switch addScreenStyle {
        case .layers: return "rectangle.on.rectangle"
        case .screen: return "rectangle.portrait"
        case .menu: return "rectangle.split.1x2"
        }
    }
}
