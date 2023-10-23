//
//  DailyCatalystWidgetBundle.swift
//  DailyCatalystWidget
//
//  Created by Asir Bygud on 10/23/23.
//

import WidgetKit
import SwiftUI

@main
struct DailyCatalystWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyCatalystWidget()
        DailyCatalystWidgetLiveActivity()
    }
}
