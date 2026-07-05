//
//  SharedComponents.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct LayoutCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.mdLine, lineWidth: 1)
            )
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.headline)
            .foregroundStyle(Color.mdInk)
    }
}

struct PlaceholderArtwork: View {
    let title: String
    let colors: [Color]

    var body: some View {
        ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            VStack(spacing: 8) {
                Image(systemName: "music.note")
                    .font(.title2.weight(.semibold))
                Text(title)
                    .font(.caption.weight(.bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(Color.white)
            .padding(8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct WaveformPreview: View {
    let color: Color

    private let heights: [CGFloat] = [0.35, 0.72, 0.48, 0.9, 0.55, 0.78, 0.42, 1.0, 0.62, 0.38, 0.86, 0.52]

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            ForEach(Array(heights.enumerated()), id: \.offset) { _, height in
                Capsule()
                    .fill(color)
                    .frame(width: 5, height: 44 * height)
            }
        }
        .frame(height: 50)
    }
}
