//
//  SharedPost.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/07/05.
//

import Foundation

struct SharedPost: Identifiable, Codable, Hashable {
    let id: UUID
    let diaryEntryID: UUID
    let title: String
    let bodyText: String
    let trackTitle: String
    let mood: String
    let createdAt: Date
    var likeCount: Int
    var isLiked: Bool

    init(
        id: UUID = UUID(),
        diaryEntryID: UUID,
        title: String,
        bodyText: String,
        trackTitle: String,
        mood: String,
        createdAt: Date = Date(),
        likeCount: Int = 0,
        isLiked: Bool = false
    ) {
        self.id = id
        self.diaryEntryID = diaryEntryID
        self.title = title
        self.bodyText = bodyText
        self.trackTitle = trackTitle
        self.mood = mood
        self.createdAt = createdAt
        self.likeCount = likeCount
        self.isLiked = isLiked
    }
}
