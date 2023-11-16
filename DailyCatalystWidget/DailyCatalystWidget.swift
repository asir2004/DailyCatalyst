//
//  DailyCatalystWidget.swift
//  DailyCatalystWidget
//
//  Created by Asir Bygud on 10/23/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), catalyst: .example2)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), catalyst: .example2)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, catalyst: .example2)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let catalyst: Catalyst
}

//struct DailyCatalystWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        Text("Hello World!")
//    }
//}

struct DailyCatalystWidget: Widget {
    let kind: String = "DailyCatalystWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CatalystWidgetView(catalyst: entry.catalyst)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Daily Catalyst Widget")
        .description("Test Description")
    }
}

#Preview(as: .systemMedium) {
    DailyCatalystWidget()
} timeline: {
    SimpleEntry(date: .now, catalyst: .example2)
    SimpleEntry(date: .now, catalyst: .example2)
}
