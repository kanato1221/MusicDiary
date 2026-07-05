//
//  CommunityView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct CommunityView: View {
    @EnvironmentObject private var communityStore: CommunityStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("みんなの投稿")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color.mdInk)
                        Text("共有された日記と音楽がここに並びます。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    if communityStore.posts.isEmpty {
                        LayoutCard {
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: "まだ投稿がありません", icon: "person.2")
                                Text("日記詳細から「共有する」を押すと、ここに投稿が表示されます。")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        ForEach(communityStore.posts) { post in
                            CommunityPostCard(post: post)
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

private struct CommunityPostCard: View {
    let post: SharedPost
    @EnvironmentObject private var communityStore: CommunityStore

    var body: some View {
        LayoutCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.mdOrange)
                        .frame(width: 38, height: 38)
                        .overlay(
                            Image(systemName: "music.note")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(Color.white)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.mdInk)
                        Text(post.createdAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                Text(post.bodyText)
                    .font(.subheadline)
                    .lineSpacing(4)
                    .foregroundStyle(Color.mdInk)

                HStack(spacing: 14) {
                    Image(systemName: "play.fill")
                        .foregroundStyle(Color.white)
                        .frame(width: 40, height: 40)
                        .background(Color.mdInk)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        Text(post.trackTitle)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.mdInk)
                        WaveformPreview(color: Color.mdOrange)
                    }

                    Spacer()
                }

                HStack(spacing: 18) {
                    Button {
                        communityStore.toggleLike(for: post)
                    } label: {
                        Label("\(post.likeCount)", systemImage: post.isLiked ? "heart.fill" : "heart")
                    }
                    .foregroundStyle(post.isLiked ? Color.mdRose : Color.secondary)

                    Button(role: .destructive) {
                        communityStore.delete(post)
                    } label: {
                        Label("削除", systemImage: "trash")
                    }

                    Spacer()
                }
                .font(.caption.weight(.semibold))
            }
        }
    }
}
