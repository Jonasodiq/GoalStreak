//
//  SoundPlayer.swift
//  GoalStreak
//
//  Created by Jonas Niyazson on 2025-05-06.
//

import AVFoundation

class SoundPlayer {
    static var audioPlayer: AVAudioPlayer?

    static func playSound(_ sound: String, type: String = "mp3") {
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
