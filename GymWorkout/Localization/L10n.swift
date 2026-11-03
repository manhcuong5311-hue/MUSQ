//
//  L10n.swift
//  GymWorkout
//
//  Vietnamese (2026-11-02) for text that lives in data rather than in view
//  literals: the coaching copy in SampleData, muscle, equipment and
//  difficulty names, stance notes and the x-ray demos. The app's own UI
//  strings go through Localizable.xcstrings the usual way (Text("…"),
//  String(localized:)).
//
//  The data table is `<lang>.lproj/Content.strings`, keyed by the English
//  string itself, so a sentence edited in SampleData simply shows in English
//  until it is translated again — Tools/localization lists those. Exercise
//  names never go through here: they stay English in every language.
//

import Foundation

enum L10n {
    /// The current language's version of a data string, or the string itself.
    static func content(_ english: String) -> String {
        guard !english.isEmpty else { return english }
        return Bundle.main.localizedString(forKey: english, value: english, table: "Content")
    }

    /// The language MUSQ is showing, in that language ("English",
    /// "Tiếng Việt"), for the Language row in Settings.
    static var currentLanguageName: String {
        let code = Bundle.main.preferredLocalizations.first ?? "en"
        let name = Locale(identifier: code).localizedString(forLanguageCode: code) ?? code
        return name.prefix(1).uppercased() + name.dropFirst()
    }
}

extension String {
    /// This data string as shown on screen, `L10n.content(self)`.
    var localizedContent: String { L10n.content(self) }
}
