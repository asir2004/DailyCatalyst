//
//  DailyCatalystWidget.swift
//  DailyCatalystWidget
//
//  Created by Asir Bygud on 10/23/23.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: AppIntentTimelineProvider {
    let dataController = DataController()
//    let coreDataManager: CoreDataManager
    
//    init() {
//        coreDataManager = CoreDataManager(dataController)
//    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), catalyst: .example)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, catalyst: DataController().randomlyPickACatalyst())
    }
    
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) { //swiftlint:disable:this line_length
//        catalystForWidget(for: configuration) { selectedCatalyst in
//            let entry = SimpleEntry(
//                date: Date(),
//                configuration: configuration,
//                catalyst: selectedCatalyst ?? .example
//            )
//            completion(entry)
//        }
//        
////        coreDataManager.fetchCatalysts()
//        
////        catalystForWidget(for: configuration) { selectedCatalyst in
////            let currentDate = Date()
////            var entries: [SimpleEntry] = []
////
////            // Create a date that's 60 minutes in the future.
////            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 60, to: currentDate)!
////
////            // Generate an Entry
////            let entry = SimpleEntry(date: currentDate, configuration: configuration, catalyst: selectedCatalyst ?? .example)
////            entries.append(entry)
////
////            let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
////            completion(timeline)
////        }
//    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let catalyst = DataController().randomlyPickACatalyst()
        let entry = SimpleEntry(date: Date(), configuration: configuration, catalyst: catalyst)
        let entries: [SimpleEntry] = [entry]
        
        return Timeline(entries: entries, policy: .atEnd)
        
//        coreDataManager.fetchCatalysts()
        
//        catalystForWidget(for: configuration) { selectedCatalyst in
////            let entry = SimpleEntry(
////                date: Date(),
////                configuration: configuration,
////                catalyst: selectedCatalyst ?? .example
////            )
////            completion(entry)
//
//            let currentDate = Date()
//            var entries: [SimpleEntry] = []
//
//            // Create a date that's 60 minutes in the future.
//            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 60, to: currentDate)!
//
//            // Generate an Entry
//            let entry = SimpleEntry(date: currentDate, configuration: configuration, catalyst: selectedCatalyst ?? .example)
//            entries.append(entry)
//
//            let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
//            completion(timeline)
//        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let catalyst: Catalyst
}

struct DailyCatalystWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        CatalystWidgetView(catalyst: entry.catalyst)
    }
}

struct DailyCatalystWidget: Widget {
    let kind: String = "DailyCatalystWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CatalystWidgetView(catalyst: entry.catalyst)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    DailyCatalystWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, catalyst: .example)
    SimpleEntry(date: .now, configuration: .starEyes, catalyst: .example)
}
