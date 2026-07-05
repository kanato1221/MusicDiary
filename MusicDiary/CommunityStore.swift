//
//  CommunityStore.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/07/05.
//

import Combine
import Foundation

@MainActor
final class CommunityStore: ObservableObject {
    @Published private(set) var posts: [SharedPost] = [] {
        didSet {
            save()
        }
    }

    private let storageKey = "musicDiary.sharedPosts"

    init() {
        load()
    }

    func publish(_ post: SharedPost) {
        posts.insert(post, at: 0)
    }

    func hasPublished(diaryEntryID: UUID) -> Bool {
        posts.contains { $0.diaryEntryID == diaryEntryID }
    }

    func toggleLike(for post: SharedPost) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else {
            return
        }

        posts[index].isLiked.toggle()
        posts[index].likeCount += posts[index].isLiked ? 1 : -1
        posts[index].likeCount = max(0, posts[index].likeCount)
    }

    func delete(_ post: SharedPost) {
        posts.removeAll { $0.id == post.id }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            posts = try JSONDecoder().decode([SharedPost].self, from: data)
        } catch {
            posts = []
        }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(posts)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            assertionFailure("Failed to save shared posts: \(error)")
        }
    }
}
