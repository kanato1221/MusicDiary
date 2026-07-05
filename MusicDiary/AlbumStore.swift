//
//  AlbumStore.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/07/05.
//

import Combine
import Foundation

@MainActor
final class AlbumStore: ObservableObject {
    @Published private(set) var albums: [CustomAlbum] = [] {
        didSet {
            save()
        }
    }

    private let storageKey = "musicDiary.customAlbums"

    init() {
        load()
    }

    func create(title: String, note: String, entryIDs: [UUID]) {
        let album = CustomAlbum(
            title: title,
            note: note,
            entryIDs: entryIDs
        )
        albums.insert(album, at: 0)
    }

    func delete(_ album: CustomAlbum) {
        albums.removeAll { $0.id == album.id }
    }

    func addEntry(_ entryID: UUID, to album: CustomAlbum) {
        guard let index = albums.firstIndex(where: { $0.id == album.id }) else {
            return
        }

        if !albums[index].entryIDs.contains(entryID) {
            albums[index].entryIDs.append(entryID)
        }
    }

    func contains(_ entryID: UUID, in album: CustomAlbum) -> Bool {
        albums.first(where: { $0.id == album.id })?.entryIDs.contains(entryID) ?? false
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            albums = try JSONDecoder().decode([CustomAlbum].self, from: data)
        } catch {
            albums = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(albums)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            assertionFailure("Failed to save custom albums: \(error)")
        }
    }
}
