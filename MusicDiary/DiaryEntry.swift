//
//  DiaryEntry.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import Foundation

struct DiaryEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let date: Date
    let bodyText: String
    let selectedTrackTitle: String
    let musicPrompt: String
    let mood: String
    let tempo: String
    let instruments: String

    init(
        id: UUID = UUID(),
        title: String,
        date: Date,
        bodyText: String,
        selectedTrackTitle: String = "",
        musicPrompt: String = "",
        mood: String = "",
        tempo: String = "",
        instruments: String = ""
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.bodyText = bodyText
        self.selectedTrackTitle = selectedTrackTitle
        self.musicPrompt = musicPrompt
        self.mood = mood
        self.tempo = tempo
        self.instruments = instruments
    }
}
