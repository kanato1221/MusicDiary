//
//  ContentView.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HubView()
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }

            AlbumsView()
                .tabItem {
                    Label(ProcessInfo.processInfo.environment["HOGE"]!, systemImage: "rectangle.stack.fill")
                }

            CommunityView()
                .tabItem {
                    Label("みんなの投稿", systemImage: "person.2.fill")
                }

            DiaryCalendarView()
                .tabItem {
                    Label("日記", systemImage: "calendar")
                }
        }
        .tint(Color.mdInk)
    }
}
