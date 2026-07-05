//
//  CustomAlbum.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/07/05.
//

import Foundation

struct CustomAlbum: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var note: String
    var entryIDs: [UUID]
    let createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        note: String,
        entryIDs: [UUID],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.note = note
        self.entryIDs = entryIDs
        self.createdAt = createdAt
    }
}
