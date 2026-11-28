//
//  MUSQWidgetsBundle.swift
//  MUSQWidgets
//
//  Entry point of the widget extension: the two Live Activities and the
//  Today widget, drawn in the picked look (IslandStyle: bold / glass /
//  minimal). Text is localized in MUSQWidgets/Localizable.xcstrings
//  (English + Vietnamese, like the app).
//

import SwiftUI
import WidgetKit

@main
struct MUSQWidgetsBundle: WidgetBundle {
    var body: some Widget {
        WorkoutLiveActivity()
        TodayLiveActivity()
        TodayWidget()
    }
}
