//
//  DiaryDetailView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct DiaryDetailView: View {
    let entry: DiaryEntry

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.date.formatted(date: .long, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(entry.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.mdInk)
                }

                LayoutCard {
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: "選んだ曲", icon: "music.note")
                        HStack(spacing: 14) {
                            Image(systemName: "play.fill")
                                .foregroundStyle(Color.white)
                                .frame(width: 44, height: 44)
                                .background(Color.mdInk)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.selectedTrackTitle.isEmpty ? "未選択" : entry.selectedTrackTitle)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(Color.mdInk)
                                WaveformPreview(color: Color.mdOrange)
                            }
                        }

                        if !entry.mood.isEmpty || !entry.tempo.isEmpty || !entry.instruments.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                DetailMetaRow(title: "Mood", value: entry.mood)
                                DetailMetaRow(title: "Tempo", value: entry.tempo)
                                DetailMetaRow(title: "Instruments", value: entry.instruments)
                            }
                        }
                    }
                }

                LayoutCard {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "日記", icon: "book.closed")
                        Text(entry.bodyText)
                            .font(.body)
                            .lineSpacing(5)
                            .foregroundStyle(Color.mdInk)
                    }
                }
            }
            .padding(18)
        }
        .background(Color.mdPaper)
        .navigationTitle("日記")
    }
}

private struct DetailMetaRow: View {
    let title: String
    let value: String

    var body: some View {
        if !value.isEmpty {
            HStack(alignment: .top) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.mdInk)
                    .frame(width: 86, alignment: .leading)
                Text(value)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
