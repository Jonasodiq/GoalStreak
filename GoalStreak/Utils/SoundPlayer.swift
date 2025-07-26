//
//  SoundPlayer.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-06.
//

import AVFoundation

class SoundPlayer {
    static var audioPlayer: AVAudioPlayer?
    static var isSoundEnabled: Bool = true // Kontrollera om ljudet är aktiverat

    static func play(_ sound: String, type: String = "mp3") {
        // Kontrollera om ljudet är aktiverat
        guard isSoundEnabled else { return }

        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("ERROR: Could not play sound '\(sound).\(type)': \(error.localizedDescription)")
            }
        } else {
            print("ERROR: Sound file '\(sound).\(type)' not found in bundle.")
        }
    }
}
