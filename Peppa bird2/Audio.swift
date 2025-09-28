//
//  File.swift
//  Peppa bird2
//
//  Created by Lukas Jordbru on 06/07/2024.
//

import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer?

func playBackgroundMusic() {
        // Ensure the audio file is in the project's bundle
        guard let url = Bundle.main.url(forResource: "peppa_background", withExtension: "mp3") else {
            print("Could not find the audio file.")
            return
        }

        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1  // Loop indefinitely
            backgroundMusicPlayer?.play()
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
