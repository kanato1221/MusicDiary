//
//  DiaryWriteView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct DiaryWriteView: View {
    let onNext: (DiaryEntry) -> Void

    @State private var title = ""
    @State private var date = Date()
    @State private var bodyText = ""

    private var canGoNext: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section("タイトル") {
                TextField("例:　部活の大会", text: $title)
            }

            Section("日付") {
                DatePicker("作成日", selection: $date, displayedComponents: .date)
            }

            Section("本文") {
                TextEditor(text: $bodyText)
                    .frame(minHeight: 260)
                    .overlay(alignment: .topLeading) {
                        if bodyText.isEmpty {
                            Text("今日見た景色、感じたこと、忘れたくない空気を書く")
                                .foregroundStyle(.secondary)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                                .allowsHitTesting(false)
                        }
                    }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.mdPaper)
        .navigationTitle("日記を書く")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    onNext(
                        DiaryEntry(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            date: date,
                            bodyText: bodyText.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                    )
                } label: {
                    Image(systemName: "arrow.right")
                }
                .disabled(!canGoNext)
                .accessibilityLabel("次へ")
            }
        }
    }
}
