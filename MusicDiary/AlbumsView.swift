//
//  AlbumsView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct AlbumsView: View {
    @EnvironmentObject private var diaryStore: DiaryStore

    private var weekEntries: [DiaryEntry] {
        diaryStore.entriesForCurrentWeek()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("今週のアルバム")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color.mdInk)
                        Text("保存した日記の曲が、週ごとのアルバムとして並びます。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    LayoutCard {
                        HStack(spacing: 14) {
                            PlaceholderArtwork(title: "WEEK", colors: [Color.mdBlue, Color.mdOrange])
                                .frame(width: 88, height: 88)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("今週の記憶")
                                    .font(.headline)
                                    .foregroundStyle(Color.mdInk)
                                Text("\(weekEntries.count)/7曲")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(Color.mdInk)
                                Text("まとめ曲は次の段階で追加")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }
                    }

                    if weekEntries.isEmpty {
                        LayoutCard {
                            VStack(alignment: .leading, spacing: 10) {
                                SectionHeader(title: "まだ曲がありません", icon: "music.note")
                                Text("ハブから日記を書いて保存すると、このアルバムに曲が追加されます。")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        VStack(spacing: 10) {
                            ForEach(weekEntries) { entry in
                                NavigationLink {
                                    DiaryDetailView(entry: entry)
                                } label: {
                                    AlbumEntryRow(entry: entry)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(18)
            }
            .background(Color.mdPaper)
            .navigationTitle("アルバム")
        }
    }
}

private struct AlbumEntryRow: View {
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
