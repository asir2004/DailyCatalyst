//
//  DailyCatalystWidgetLiveActivity.swift
//  DailyCatalystWidget
//
//  Created by Asir Bygud on 10/23/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DailyCatalystWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DailyCatalystWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DailyCatalystWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DailyCatalystWidgetAttributes {
    fileprivate static var preview: DailyCatalystWidgetAttributes {
        DailyCatalystWidgetAttributes(name: "World")
    }
}

extension DailyCatalystWidgetAttributes.ContentState {
    fileprivate static var smiley: DailyCatalystWidgetAttributes.ContentState {
        DailyCatalystWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DailyCatalystWidgetAttributes.ContentState {
         DailyCatalystWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DailyCatalystWidgetAttributes.preview) {
   DailyCatalystWidgetLiveActivity()
} contentStates: {
    DailyCatalystWidgetAttributes.ContentState.smiley
    DailyCatalystWidgetAttributes.ContentState.starEyes
}
