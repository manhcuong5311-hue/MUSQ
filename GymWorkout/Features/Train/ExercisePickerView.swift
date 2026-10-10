//
//  ExercisePickerView.swift
//  GymWorkout
//
//  Picks an exercise from the existing library: exercises that train the
//  current group first, then everything else. Search covers both.
//
//  On iPad it's a form sheet that opens ready to type, with the section
//  titles held at the top as the list scrolls under them.
//

import SwiftUI

struct ExercisePickerView: View {
    var group: MuscleGroup
    var title: String
    /// Names already in the group's list, marked rather than hidden.
    var alreadyAdded: Set<String> = []
    var onPick: (String) -> Void

    /// The presenting window's tier: the sheet's own is resolved inside.
    @Environment(\.dsLayout) private var layout

    var body: some View {
        PickerContent(group: group, title: title, alreadyAdded: alreadyAdded, onPick: onPick)
            .dsLayoutRoot()
            .background(DS.surface.ignoresSafeArea())
            // Outside the layout root: sized by the window it opens over.
            .dsSheetSizing(.form)
            // A form sheet on iPad isn't dragged down; the phone's still is.
            .presentationDragIndicator(layout.isRegular ? .hidden : .visible)
            .presentationBackground(DS.surface)
            .presentationCornerRadius(DS.Metric.sheetRadius)
    }
}

/// The picker inside its sheet, where `dsLayout` is the sheet's own.
private struct PickerContent: View {
    var group: MuscleGroup
    var title: String
    var alreadyAdded: Set<String>
    var onPick: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.dsLayout) private var layout
    @State private var query = ""
    @FocusState private var searchFocused: Bool

    private func matches(_ exercise: Exercise) -> Bool {
        query.isEmpty
            || exercise.name.localizedCaseInsensitiveContains(query)
            || exercise.meta.localizedCaseInsensitiveContains(query)
    }

    private var recommended: [Exercise] {
        ExerciseCatalog.exercises(for: group).filter(matches)
    }

    private var others: [Exercise] {
        let shown = Set(ExerciseCatalog.exercises(for: group).map(\.name))
        return SampleData.exercises.filter { !shown.contains($0.name) && matches($0) }
    }

    /// The sheet's side margin: the phone's gutter, or the tier's.
    private var gutter: CGFloat { layout.isRegular ? layout.gutter : DS.Metric.gutter }

    var body: some View {
        let regular = layout.isRegular
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 0) {
                    MetaLine(text: group.title.uppercased(), em: 0.10)
                    Text(title)
                        .font(.ui(regular ? layout.text(.sheetTitle) : 22, .semibold))
                        .tracking(regular ? -0.55 : -0.45)
                        .foregroundStyle(DS.silver)
                        .padding(.top, 5)
                }
                Spacer()
                Button("Close") { dismiss() }
                    .font(.ui(regular ? 14 : 13, .semibold))
                    .foregroundStyle(DS.silver)
                    .buttonStyle(.plain)
                    .applying(DS.isPad) { close in
                        close
                            .keyboardShortcut(.cancelAction)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .dsHover(.highlight)
                            .padding(.horizontal, -10)
                    }
            }
            .padding(.horizontal, gutter)
            .padding(.top, regular ? 28 : 24)

            searchField
                .padding(.horizontal, gutter)
                .padding(.top, 16)

            ScrollView(showsIndicators: false) {
                // Held headers only where the list is long enough to lose
                // its place in; the phone keeps them scrolling away.
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: regular ? [.sectionHeaders] : []) {
                    if !recommended.isEmpty {
                        section("RECOMMENDED FOR \(group.title.uppercased())", recommended)
                    }
                    if !others.isEmpty {
                        section("ALL EXERCISES", others)
                    }
                    if recommended.isEmpty && others.isEmpty {
                        Text("No exercises match “\(query)”.")
                            .font(.ui(regular ? 14 : 13))
                            .foregroundStyle(DS.silver.opacity(0.5))
                            .padding(.top, 30)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, gutter)
                .padding(.bottom, 30)
            }
            .padding(.top, 6)
        }
        .modifier(SearchFocusOnOpen(enabled: regular, focus: $searchFocused))
    }

    private var searchField: some View {
        HStack(spacing: 9) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(DS.silver.opacity(0.4))
            TextField("", text: $query,
                      prompt: Text("Search exercises").foregroundStyle(DS.silver.opacity(0.35)))
                .focused($searchFocused)
                .font(.ui(15))
                .foregroundStyle(DS.silver)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 13)
        .padding(.vertical, 11)
        .background(RoundedRectangle(cornerRadius: 13, style: .continuous).fill(DS.surfaceDim))
        .overlay(RoundedRectangle(cornerRadius: 13, style: .continuous)
            .strokeBorder(DS.silver.opacity(0.07), lineWidth: 1))
    }

    private func section(_ title: String, _ exercises: [Exercise]) -> some View {
        Section {
            ForEach(exercises) { exercise in
                Button {
                    onPick(exercise.name)
                    dismiss()
                } label: {
                    pickerRow(exercise)
                }
                .buttonStyle(.plain)
            }
        } header: {
            SectionEyebrow(text: title, size: layout.isRegular ? 11 : 10)
                .padding(.top, 18)
                .padding(.bottom, 6)
                .frame(maxWidth: layout.isRegular ? .infinity : nil, alignment: .leading)
                // A held header covers the rows passing under it.
                .background(layout.isRegular ? DS.surface : .clear)
        }
    }

    private func pickerRow(_ exercise: Exercise) -> some View {
        let role = ExerciseCatalog.role(of: group, in: exercise)
        let regular = layout.isRegular
        let thumb: CGFloat = regular ? 56 : 46
        let radius: CGFloat = regular ? 13 : 11
        return HStack(spacing: regular ? 14 : 12) {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(DS.surfaceDim)
                .frame(width: thumb, height: thumb)
                .overlay(RenderSlot(id: exercise.slotID)
                    .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous)))

            VStack(alignment: .leading, spacing: regular ? 5 : 4) {
                Text(exercise.name)
                    .font(.ui(regular ? 15.5 : 14.5, .semibold))
                    .foregroundStyle(DS.silver)
                MetaLine(text: exercise.meta, size: regular ? 10 : 9, em: 0.05)
            }

            Spacer(minLength: 6)

            if alreadyAdded.contains(exercise.name) {
                tag("ADDED")
            } else if let role {
                tag(role == .primary ? "PRIMARY" : "SECONDARY")
            }
        }
        .padding(.vertical, regular ? 11 : 9)
        .overlay(alignment: .bottom) { Hairline(opacity: 0.06) }
        .contentShape(Rectangle())
        .dsHover(.highlight, radius: 12)
    }

    private func tag(_ text: String) -> some View {
        let size: CGFloat = layout.isRegular ? 9.5 : 8.5
        return Text(text)
            .font(.mono(size, .semibold))
            .trackingEm(0.08, size: size)
            .foregroundStyle(DS.silver.opacity(0.55))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(RoundedRectangle(cornerRadius: 5, style: .continuous).fill(DS.silver.opacity(0.08)))
    }
}

/// Opens the iPad picker with the cursor in the search field, so typing
/// starts at once — with a hardware keyboard the usual way in.
private struct SearchFocusOnOpen: ViewModifier {
    var enabled: Bool
    var focus: FocusState<Bool>.Binding

    func body(content: Content) -> some View {
        if enabled {
            content.defaultFocus(focus, true)
        } else {
            content
        }
    }
}

extension View {
    /// Applies `transform` only when `condition` holds. For conditions fixed
    /// for the run (the device), so the view's identity never flips.
    @ViewBuilder
    fileprivate func applying<V: View>(_ condition: Bool, _ transform: (Self) -> V) -> some View {
        if condition { transform(self) } else { self }
    }
}
