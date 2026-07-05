//
//  HubView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

enum HubRoute: Hashable {
    case diaryWrite
    case musicGeneration(DiaryEntry)
    case saved
}

struct HubView: View {
    @EnvironmentObject private var diaryStore: DiaryStore
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.mdPaper.ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

                    VStack(spacing: 12) {
                        Text("Music Diary")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(Color.mdInk)
                        Text("今日の感情を、15秒の音楽として残す")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        path.append(HubRoute.diaryWrite)
                    } label: {
                        Label("日記を書く", systemImage: "square.and.pencil")
                            .font(.title3.weight(.bold))
                            .frame(width: 220, height: 64)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.mdInk)

                    Spacer()
                }
            }
            .navigationTitle("home")
            .navigationDestination(for: HubRoute.self) { route in
                switch route {
                case .diaryWrite:
                    DiaryWriteView { entry in
                        path.append(HubRoute.musicGeneration(entry))
                    }
                case .musicGeneration(let entry):
                    MusicSelectionView(entry: entry) { savedEntry in
                        diaryStore.add(savedEntry)
                        path.append(HubRoute.saved)
                    }
                case .saved:
                    SaveCompleteView {
                        path.removeLast(path.count)
                    }
                }
            }
        }
    }
}
