//
//  AlbumsView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct AlbumsView: View {
    @EnvironmentObject private var diaryStore: DiaryStore
    @EnvironmentObject private var albumStore: AlbumStore

    private var weekEntries: [DiaryEntry] {
        diaryStore.entriesForCurrentWeek()
    }

    private let columns = [
        GridItem(.adaptive(minimum: 148), spacing: 18)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 24) {
                        NavigationLink {
                            WeekAlbumDetailView(entries: weekEntries)
                        } label: {
                            AlbumGridTile(
                                title: "今週の記憶",
                                subtitle: "\(weekEntries.count)/7曲",
                                artworkTitle: "WEEK",
                                colors: [Color.mdBlue, Color.mdOrange]
                            )
                        }
                        .buttonStyle(.plain)

                        ForEach(albumStore.albums) { album in
                            NavigationLink {
                                CustomAlbumDetailView(album: album)
                            } label: {
                                AlbumGridTile(
                                    title: album.title,
                                    subtitle: "\(album.entryIDs.count)曲",
                                    artworkTitle: "MIX",
                                    colors: [Color.mdGreen, Color.mdPurple]
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if albumStore.albums.isEmpty {
                        Text("左上の＋から曲を選んで、新しいアルバムを作れます。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top, 2)
                    }
                }
                .padding(18)
            }
            .background(Color.mdPaper)
            .navigationTitle("アルバム")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    NavigationLink {
                        CreateAlbumView()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("アルバムを作成")
                }

                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink {
                        AlbumTracksView()
                    } label: {
                        Image(systemName: "music.note.list")
                    }
                    .accessibilityLabel("曲一覧")
                }
            }
        }
    }
}

private struct WeekAlbumDetailView: View {
    let entries: [DiaryEntry]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                AlbumHero(
                    title: "今週の記憶",
                    subtitle: "\(entries.count)/7曲",
                    note: "日曜日に1週間のアルバムとしてまとまります。",
                    artworkTitle: "WEEK",
                    colors: [Color.mdBlue, Color.mdOrange]
                )

                VStack(spacing: 10) {
                    if entries.isEmpty {
                        LayoutCard {
                            Text("今週はまだ保存済みの曲がありません。")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        ForEach(entries) { entry in
                            AlbumTrackListRow(entry: entry)
                        }
                    }
                }
            }
            .padding(18)
        }
        .background(Color.mdPaper)
        .navigationTitle("今週の記憶")
    }
}

private struct AlbumGridTile: View {
    let title: String
    let subtitle: String
    let artworkTitle: String
    let colors: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PlaceholderArtwork(title: artworkTitle, colors: colors)
                .aspectRatio(1, contentMode: .fit)
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.mdInk)
                .lineLimit(1)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct AlbumHero: View {
    let title: String
    let subtitle: String
    let note: String
    let artworkTitle: String
    let colors: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            PlaceholderArtwork(title: artworkTitle, colors: colors)
                .aspectRatio(1, contentMode: .fit)
                .shadow(color: Color.black.opacity(0.14), radius: 10, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.mdInk)
                Text(subtitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color.mdInk)
                if !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

private struct CreateAlbumView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var diaryStore: DiaryStore
    @EnvironmentObject private var albumStore: AlbumStore

    @State private var title = ""
    @State private var note = ""
    @State private var selectedEntryIDs: Set<UUID> = []

    private var entries: [DiaryEntry] {
        diaryStore.entries.sorted { $0.date > $1.date }
    }

    private var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !selectedEntryIDs.isEmpty
    }

    var body: some View {
        Form {
            Section("アルバム名") {
                TextField("例: 夕方の曲", text: $title)
            }

            Section("メモ") {
                TextField("例: 帰り道に聴きたい記憶", text: $note)
            }

            Section("曲を選ぶ") {
                if entries.isEmpty {
                    Text("まだ保存済みの曲がありません。")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(entries) { entry in
                        Button {
                            toggle(entry.id)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: selectedEntryIDs.contains(entry.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selectedEntryIDs.contains(entry.id) ? Color.mdInk : Color.mdLine)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(entry.selectedTrackTitle.isEmpty ? entry.title : entry.selectedTrackTitle)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(Color.mdInk)
                                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Button {
                createAlbum()
            } label: {
                Label("アルバムを作成", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .disabled(!canCreate)
        }
        .scrollContentBackground(.hidden)
        .background(Color.mdPaper)
        .navigationTitle("新規アルバム")
    }

    private func toggle(_ id: UUID) {
        if selectedEntryIDs.contains(id) {
            selectedEntryIDs.remove(id)
        } else {
            selectedEntryIDs.insert(id)
        }
    }

    private func createAlbum() {
        albumStore.create(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
            entryIDs: Array(selectedEntryIDs)
        )
        dismiss()
    }
}

private struct CustomAlbumDetailView: View {
    let album: CustomAlbum
    @EnvironmentObject private var diaryStore: DiaryStore

    private var entries: [DiaryEntry] {
        album.entryIDs.compactMap { id in
            diaryStore.entries.first { $0.id == id }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                AlbumHero(
                    title: album.title,
                    subtitle: "\(entries.count)曲",
                    note: album.note,
                    artworkTitle: "MIX",
                    colors: [Color.mdGreen, Color.mdPurple]
                )

                VStack(spacing: 10) {
                    ForEach(entries) { entry in
                        AlbumTrackListRow(entry: entry)
                    }
                }
            }
            .padding(18)
        }
        .background(Color.mdPaper)
        .navigationTitle("アルバム")
    }
}

private struct CustomAlbumRow: View {
    let album: CustomAlbum

    var body: some View {
        LayoutCard {
            HStack(spacing: 14) {
                PlaceholderArtwork(title: "MIX", colors: [Color.mdGreen, Color.mdPurple])
                    .frame(width: 72, height: 72)

                VStack(alignment: .leading, spacing: 6) {
                    Text(album.title)
                        .font(.headline)
                        .foregroundStyle(Color.mdInk)
                    Text("\(album.entryIDs.count)曲")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.mdInk)
                    if !album.note.isEmpty {
                        Text(album.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct AlbumTracksView: View {
    @EnvironmentObject private var diaryStore: DiaryStore
    @EnvironmentObject private var albumStore: AlbumStore

    private var entries: [DiaryEntry] {
        diaryStore.entries.sorted { $0.date > $1.date }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if entries.isEmpty {
                    LayoutCard {
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "まだ曲がありません", icon: "music.note")
                            Text("ハブから日記を書いて保存すると、この一覧に曲が追加されます。")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    ForEach(entries) { entry in
                        AlbumTrackListRow(entry: entry)
                    }
                }
            }
            .padding(18)
        }
        .background(Color.mdPaper)
        .navigationTitle("曲一覧")
    }
}

private struct AlbumTrackListRow: View {
    let entry: DiaryEntry

    var body: some View {
        LayoutCard {
            HStack(spacing: 14) {
                NavigationLink {
                    DiaryDetailView(entry: entry)
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "play.fill")
                            .foregroundStyle(Color.white)
                            .frame(width: 42, height: 42)
                            .background(Color.mdInk)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 5) {
                            Text(entry.selectedTrackTitle.isEmpty ? entry.title : entry.selectedTrackTitle)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(Color.mdInk)
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                NavigationLink {
                    AddTrackToAlbumView(entry: entry)
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundStyle(Color.mdInk)
                }
                .accessibilityLabel("アルバムに追加")
            }
        }
    }
}

private struct AddTrackToAlbumView: View {
    let entry: DiaryEntry
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var albumStore: AlbumStore

    var body: some View {
        List {
            if albumStore.albums.isEmpty {
                Section {
                    Text("まだアルバムがありません。アルバム画面左上の＋から先にアルバムを作成してください。")
                        .foregroundStyle(.secondary)
                }
            } else {
                Section("追加先を選ぶ") {
                    ForEach(albumStore.albums) { album in
                        Button {
                            albumStore.addEntry(entry.id, to: album)
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                PlaceholderArtwork(title: "MIX", colors: [Color.mdGreen, Color.mdPurple])
                                    .frame(width: 44, height: 44)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(album.title)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(Color.mdInk)
                                    Text("\(album.entryIDs.count)曲")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                if albumStore.contains(entry.id, in: album) {
                                    Text("追加済み")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(Color.mdInk)
                                }
                            }
                        }
                        .disabled(albumStore.contains(entry.id, in: album))
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.mdPaper)
        .navigationTitle("アルバムに追加")
    }
}

private struct AlbumTrackRow: View {
    let entry: DiaryEntry

    var body: some View {
        LayoutCard {
            HStack(spacing: 14) {
                Image(systemName: "play.fill")
                    .foregroundStyle(Color.white)
                    .frame(width: 42, height: 42)
                    .background(Color.mdInk)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.selectedTrackTitle.isEmpty ? entry.title : entry.selectedTrackTitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.mdInk)
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
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
}
