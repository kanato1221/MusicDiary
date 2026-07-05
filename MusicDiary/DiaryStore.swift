//
//  DiaryStore.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import Combine
import Foundation

@MainActor
final class DiaryStore: ObservableObject {
    @Published private(set) var entries: [DiaryEntry] = [] {
        didSet {
            save()
        }
    }

    private let storageKey = "musicDiary.entries"

    init() {
        load()
    }

    func add(_ entry: DiaryEntry) {
        entries.insert(entry, at: 0)
    }

    func entries(onDay day: Int) -> [DiaryEntry] {
        entries.filter { Calendar.current.component(.day, from: $0.date) == day }
    }

    func entries(on date: Date) -> [DiaryEntry] {
        entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func entriesForCurrentWeek() -> [DiaryEntry] {
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: Date()) else {
            return entries
        }

        return entries
            .filter { weekInterval.contains($0.date) }
            .sorted { $0.date < $1.date }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            entries = try JSONDecoder().decode([DiaryEntry].self, from: data)
        } catch {
            entries = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            assertionFailure("Failed to save diary entries: \(error)")
        }
    }
}
