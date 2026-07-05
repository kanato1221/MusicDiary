//
//  ShareEntryView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/07/05.
//

import SwiftUI

struct ShareEntryView: View {
    let entry: DiaryEntry

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var communityStore: CommunityStore
    @State private var publicTitle: String
    @State private var publicBody: String

    init(entry: DiaryEntry) {
        self.entry = entry
        _publicTitle = State(initialValue: entry.title)
        _publicBody = State(initialValue: String(entry.bodyText.prefix(120)))
    }

    private var canPublish: Bool {
        !publicTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !publicBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("共有前に内容を確認")
                        .font(.headline)
                        .foregroundStyle(Color.mdInk)
                    Text("日記は個人的な内容が入りやすいので、公開してよい部分だけに整えてから投稿します。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section("公開タイトル") {
                TextField("タイトル", text: $publicTitle)
            }

            Section("公開する文章") {
                TextEditor(text: $publicBody)
                    .frame(minHeight: 160)
            }

            Section("共有される曲") {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .foregroundStyle(Color.white)
                        .frame(width: 40, height: 40)
                        .background(Color.mdInk)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.selectedTrackTitle.isEmpty ? "今日の曲" : entry.selectedTrackTitle)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.mdInk)
                        Text(entry.mood.isEmpty ? "Mood未設定" : entry.mood)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Button {
                publish()
            } label: {
                Label("投稿する", systemImage: "paperplane.fill")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!canPublish)
        }
        .scrollContentBackground(.hidden)
        .background(Color.mdPaper)
        .navigationTitle("共有する")
    }

    private func publish() {
        let post = SharedPost(
            diaryEntryID: entry.id,
            title: publicTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            bodyText: publicBody.trimmingCharacters(in: .whitespacesAndNewlines),
            trackTitle: entry.selectedTrackTitle.isEmpty ? "今日の曲" : entry.selectedTrackTitle,
            mood: entry.mood
        )
        communityStore.publish(post)
        dismiss()
    }
}
