//
//  DiaryCalendarView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct DiaryCalendarView: View {
    @EnvironmentObject private var diaryStore: DiaryStore
    @State private var displayedMonth = Calendar.current.startOfMonth(for: Date())
    @State private var selectedDate = Date()

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    private var selectedEntries: [DiaryEntry] {
        diaryStore.entries(on: selectedDate)
    }

    private var daysInDisplayedMonth: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
            let dayRange = calendar.range(of: .day, in: .month, for: displayedMonth)
        else {
            return []
        }

        return dayRange.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start)
        }
    }

    private var leadingBlankCount: Int {
        guard let firstDay = daysInDisplayedMonth.first else {
            return 0
        }

        let weekday = calendar.component(.weekday, from: firstDay)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    monthHeader
                    calendarGrid
                    selectedDiaryCard
                }
                .padding(18)
            }
            .background(Color.mdPaper)
            .navigationTitle("diary")
        }
    }

    private var monthHeader: some View {
        HStack {
            Button {
                moveMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.bordered)

            Spacer()

            Text(monthTitle(for: displayedMonth))
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.mdInk)

            Spacer()

            Button {
                moveMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.bordered)
        }
    }

    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(["日", "月", "火", "水", "木", "金", "土"], id: \.self) { weekday in
                Text(weekday)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }

            ForEach(0..<leadingBlankCount, id: \.self) { _ in
                Color.clear
                    .frame(height: 48)
            }

            ForEach(daysInDisplayedMonth, id: \.self) { date in
                dayCell(for: date)
            }
        }
    }

    private var selectedDiaryCard: some View {
        LayoutCard {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeader(title: selectedDateTitle, icon: "book.closed")

                if selectedEntries.isEmpty {
                    Text("この日の日記はまだありません。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(selectedEntries) { entry in
                        NavigationLink {
                            DiaryDetailView(entry: entry)
                        } label: {
                            DiaryEntryRow(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var selectedDateTitle: String {
        "\(calendar.component(.day, from: selectedDate))日の日記"
    }

    private func dayCell(for date: Date) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDateInToday(date)
        let hasEntry = !diaryStore.entries(on: date).isEmpty

        return Button {
            selectedDate = date
        } label: {
            VStack(spacing: 5) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.subheadline.weight(.semibold))
                Circle()
                    .fill(hasEntry ? Color.mdOrange : Color.clear)
                    .frame(width: 5, height: 5)
            }
            .foregroundStyle(isSelected ? Color.white : Color.mdInk)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.mdInk : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday && !isSelected ? Color.mdOrange : Color.mdLine, lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func moveMonth(by value: Int) {
        guard let nextMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) else {
            return
        }

        displayedMonth = calendar.startOfMonth(for: nextMonth)

        if !calendar.isDate(selectedDate, equalTo: displayedMonth, toGranularity: .month) {
            selectedDate = displayedMonth
        }
    }

    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: date)
    }
}

private struct DiaryEntryRow: View {
    let entry: DiaryEntry

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "play.fill")
                .foregroundStyle(Color.white)
                .frame(width: 40, height: 40)
                .background(Color.mdInk)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.mdInk)
                Text(entry.selectedTrackTitle.isEmpty ? "曲は未選択" : entry.selectedTrackTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
        }
    }
}

private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        dateInterval(of: .month, for: date)?.start ?? date
    }
}
