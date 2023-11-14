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
        SimpleEntry(date: Date(), catalyst: .example)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), catalyst: DataController().randomlyPickACatalyst())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        // Create a timeline entry for "now."
        let date = Date()
        let entry = SimpleEntry(
            date: date,
            catalyst: DataController().randomlyPickACatalyst()
        )


        // Create a date that's 5 seconds in the future.
        let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 5, to: date)!


        // Create the timeline with the entry and a reload policy with the date
        // for the next update.
        let timeline = Timeline(
            entries:[entry],
            policy: .after(nextUpdateDate)
        )


        // Call the completion to pass the timeline to WidgetKit.
        return timeline
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
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
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemMedium) {
    DailyCatalystWidget()
} timeline: {
    SimpleEntry(date: .now, catalyst: .example)
    SimpleEntry(date: .now, catalyst: .example)
}
