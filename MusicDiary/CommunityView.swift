//
//  CommunityView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("みんなの投稿")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color.mdInk)

                    ForEach(0..<4, id: \.self) { index in
                        LayoutCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 10) {
                                    Circle()
                                        .fill([Color.mdBlue, Color.mdOrange, Color.mdGreen, Color.mdPurple][index])
                                        .frame(width: 38, height: 38)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("User \(index + 1)")
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(Color.mdInk)
                                        Text("今日の15秒")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                }

                                HStack(spacing: 14) {
                                    Image(systemName: "play.fill")
                                        .foregroundStyle(Color.white)
                                        .frame(width: 38, height: 38)
                                        .background(Color.mdInk)
                                        .clipShape(Circle())
                                    WaveformPreview(color: [Color.mdBlue, Color.mdOrange, Color.mdGreen, Color.mdPurple][index])
                                    Spacer()
                                }

                                HStack(spacing: 18) {
                                    Label("いいね", systemImage: "heart")
                                    Label("コメント", systemImage: "bubble.right")
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(18)
            }
            .background(Color.mdPaper)
            .navigationTitle("みんなの投稿")
        }
    }
}
