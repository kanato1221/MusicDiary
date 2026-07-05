//
//  SaveCompleteView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct SaveCompleteView: View {
    let onBackToHub: () -> Void

    var body: some View {
        ZStack {
            Color.mdPaper.ignoresSafeArea()

            VStack(spacing: 22) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(Color.mdGreen)

                VStack(spacing: 8) {
                    Text("保存が完了しました")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.mdInk)
                    Text("今日の日記と15秒の曲を保存しました。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Button(action: onBackToHub) {
                    Text("ホームに戻る")
                        .font(.headline)
                        .frame(width: 180, height: 48)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.mdInk)
            }
            .padding(24)
        }
        .navigationTitle("保存完了")
    }
}
