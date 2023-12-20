//
//  DailyCatalystWidget.swift
//  DailyCatalystWidget
//
//  Created by Asir Bygud on 10/23/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let dataController: DataController
    
    init() {
        do {
            dataController = DataController.init()
        }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry.placeholderEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry.placeholderEntry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        /*
         modelContainer.mainContext requires main actor.
         This method returns immediately, but calls the completion handler at the end of the task.
         */
        Task { @MainActor in
            var fetchDescriptor = FetchDescriptor(sortBy: [SortDescriptor(\Trip.startDate, order: .forward)])
            let now = Date.now
            fetchDescriptor.predicate = #Predicate { $0.endDate >= now }
            if let upcomingTrips = try? modelContainer.mainContext.fetch(fetchDescriptor) {
                if let trip = upcomingTrips.first {
                    let newEntry = SimpleEntry(date: .now,
                                               startDate: trip.startDate,
                                               endDate: trip.endDate,
                                               name: trip.name,
                                               destination: trip.destination)
                    let timeline = Timeline(entries: [newEntry], policy: .after(newEntry.endDate))
                    completion(timeline)
                    return
                }
            }
            /**
             Return "No Trips" entry with .never policy when there is no upcoming trip.
             The main app triggers a widget update when adding a new trip.
             */
            let newEntry = SimpleEntry(date: .now,
                                       startDate: .now,
                                       endDate: .now,
                                       name: "No Trips",
                                       destination: "")
            let timeline = Timeline(entries: [newEntry], policy: .never)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let catalyst: Catalyst
    
    static var placeholderEntry: SimpleEntry {
        return SimpleEntry(date: .now, catalyst: .example)
    }
}

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
