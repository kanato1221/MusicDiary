//
//  MusicDiaryApp.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

@main
struct MusicDiaryApp: App {
    @StateObject private var diaryStore = DiaryStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(diaryStore)
        }
    }
}
