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
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), catalyst: DataController().randomlyPickACatalyst())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, catalyst: DataController().randomlyPickACatalyst())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let catalyst = DataController().randomlyPickACatalyst()
        let entry = SimpleEntry(date: Date(), configuration: configuration, catalyst: catalyst)
        let entries: [SimpleEntry] = [entry]
        
        return Timeline(entries: entries, policy: .atEnd)
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
//        Text("Hello World!")
        CatalystWidgetView(catalyst: entry.catalyst)
    }
}

func getRandomCatalyst() -> Catalyst {
    return DataController().randomlyPickACatalyst()
}

struct DailyCatalystWidget: Widget {
    let kind: String = "DailyCatalystWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            DailyCatalystWidgetEntryView(entry: entry)
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

#Preview(as: .systemSmall) {
    DailyCatalystWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, catalyst: .example)
    SimpleEntry(date: .now, configuration: .starEyes, catalyst: .example)
}
