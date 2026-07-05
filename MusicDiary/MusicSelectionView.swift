//
//  MusicSelectionView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct MusicSelectionView: View {
    let entry: DiaryEntry
    let onSave: (DiaryEntry) -> Void

    private var idea: GeneratedMusicIdea {
        MusicPromptGenerator.generate(from: entry)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("今日の音楽")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.mdInk)
                    Text("日記から15秒の曲の設計を作りました。これは仮生成です。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                LayoutCard {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 14) {
                            Image(systemName: "play.fill")
                                .foregroundStyle(Color.white)
                                .frame(width: 48, height: 48)
                                .background(Color.mdInk)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(idea.title)
                                    .font(.headline)
                                    .foregroundStyle(Color.mdInk)
                                Text("15秒 / instrumental")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                        }

                        WaveformPreview(color: Color.mdOrange)

                        VStack(alignment: .leading, spacing: 8) {
                            MusicInfoRow(title: "Mood", value: idea.mood)
                            MusicInfoRow(title: "Tempo", value: idea.tempo)
                            MusicInfoRow(title: "Instruments", value: idea.instruments)
                        }
                    }
                }

                Button {
                    let savedEntry = DiaryEntry(
                        id: entry.id,
                        title: entry.title,
                        date: entry.date,
                        bodyText: entry.bodyText,
                        selectedTrackTitle: idea.title,
                        musicPrompt: idea.prompt,
                        mood: idea.mood,
                        tempo: idea.tempo,
                        instruments: idea.instruments
                    )
                    onSave(savedEntry)
                } label: {
                    Label("この曲で保存", systemImage: "checkmark")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color.mdInk)
                .padding(.top, 8)
            }
            .padding(18)
        }
        .background(Color.mdPaper)
        .navigationTitle("曲を生成")
    }
}

private struct MusicInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.mdInk)
                .frame(width: 86, alignment: .leading)
            Text(value)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}
