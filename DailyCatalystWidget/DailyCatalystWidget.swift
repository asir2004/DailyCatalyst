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
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct DailyCatalystWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
//        Text("Hello World!")
//        CatalystWidgetView()
        ZStack {
//            Image("TestJpeg")
//                .resizable()
//                .scaledToFill()
//                .frame(maxWidth: .infinity)
//                .clipped()
//                .mask(RadialGradient(
//                    gradient: Gradient(stops: [
//                        .init(color: .black.opacity(0.5), location: 0),
//                        .init(color: .clear, location: 1)
//                    ]),
//                    center: .bottomTrailing,
//                    startRadius: 0,
//                    endRadius: 200
//                ))
//                .frame(alignment: .bottomTrailing)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(spacing: 5) {
                                Image(systemName: "person")
                                    .imageScale(.small)
                            }
                            
                            Text("Identities")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .italic()
                        }
                        
                        Text("Title")
                            .font(.title2)
                            .lineLimit(2)
                        Text("Effect Here")
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(Date.now.formatted(date: .numeric, time: .omitted))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
            Circle()
                .foregroundStyle(.yellow)
                .frame(height: 130)
                .opacity(Double(3) * 0.1)
                .blur(radius: Double(3) * 50)
                .frame(alignment: .bottom)
                .offset(y: 70)
        }
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
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
