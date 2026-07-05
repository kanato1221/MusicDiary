//
//  MusicPromptGenerator.swift
//  MusicDiary
//
//  Created by 松井奏人 on 2026/06/21.
//

import Foundation

struct GeneratedMusicIdea {
    let title: String
    let mood: String
    let tempo: String
    let instruments: String
    let prompt: String
}

enum MusicPromptGenerator {
    static func generate(from entry: DiaryEntry) -> GeneratedMusicIdea {
        let text = "\(entry.title) \(entry.bodyText)"
        let mood = detectMood(in: text)
        let scene = detectScene(in: text)
        let tempo = tempo(for: mood)
        let instruments = instruments(for: mood, scene: scene)
        let title = title(for: entry.title, mood: mood, scene: scene)

        let prompt = """
        Create a 15-second instrumental track for a personal diary memory. Mood: \(mood). Scene: \(scene). Tempo: \(tempo). Instruments: \(instruments). The track should feel intimate, reflective, and cinematic, without vocals, famous artist references, or copyrighted melodies. It should help the listener remember the emotion and scenery of this diary entry.
        """

        return GeneratedMusicIdea(
            title: title,
            mood: mood,
            tempo: tempo,
            instruments: instruments,
            prompt: prompt
        )
    }

    private static func detectMood(in text: String) -> String {
        if containsAny(["嬉しい", "楽しい", "笑", "最高", "好き", "幸せ"], in: text) {
            return "warm and happy"
        }
        if containsAny(["寂しい", "さみしい", "孤独", "泣", "別れ"], in: text) {
            return "lonely and tender"
        }
        if containsAny(["疲れ", "眠い", "しんどい", "大変"], in: text) {
            return "tired but calm"
        }
        if containsAny(["緊張", "不安", "怖", "焦"], in: text) {
            return "delicate and tense"
        }
        if containsAny(["夕方", "夕焼け", "夜", "帰り道", "雨"], in: text) {
            return "nostalgic and quiet"
        }
        return "peaceful and reflective"
    }

    private static func detectScene(in text: String) -> String {
        if containsAny(["雨", "傘", "水滴"], in: text) {
            return "rainy streets and soft reflections"
        }
        if containsAny(["夕方", "夕焼け", "オレンジ"], in: text) {
            return "a soft orange evening sky"
        }
        if containsAny(["夜", "星", "コンビニ"], in: text) {
            return "a quiet night walk under city lights"
        }
        if containsAny(["学校", "教室", "放課後"], in: text) {
            return "an after-school classroom and hallway"
        }
        if containsAny(["家族", "子ども", "赤ちゃん"], in: text) {
            return "a small family moment at home"
        }
        return "an ordinary daily scene remembered with emotion"
    }

    private static func tempo(for mood: String) -> String {
        switch mood {
        case "warm and happy":
            return "medium, 92 bpm"
        case "delicate and tense":
            return "slow-medium, 78 bpm"
        case "tired but calm", "lonely and tender":
            return "slow, 68 bpm"
        default:
            return "slow-medium, 76 bpm"
        }
    }

    private static func instruments(for mood: String, scene: String) -> String {
        if scene.contains("rainy") {
            return "felt piano, soft marimba, brushed percussion, airy pads"
        }
        if mood == "warm and happy" {
            return "clean guitar, light piano, warm bass, gentle drums"
        }
        if mood == "lonely and tender" {
            return "felt piano, muted strings, distant synth pad"
        }
        if mood == "delicate and tense" {
            return "minimal piano, pulsing soft synth, subtle strings"
        }
        return "felt piano, warm ambient synth, soft electric guitar"
    }

    private static func title(for diaryTitle: String, mood: String, scene: String) -> String {
        if !diaryTitle.isEmpty {
            return "\(diaryTitle) の音"
        }
        if scene.contains("evening") {
            return "夕方の記憶"
        }
        if mood == "warm and happy" {
            return "小さな嬉しさ"
        }
        return "今日の余韻"
    }

    private static func containsAny(_ keywords: [String], in text: String) -> Bool {
        keywords.contains { text.localizedCaseInsensitiveContains($0) }
    }
}
