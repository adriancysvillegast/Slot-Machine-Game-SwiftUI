//
//  PlaySound.swift
//  Slot Machine
//
//  Created by Adriancys Jesus Villegas Toro on 31/10/23.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?


func playsound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        }catch {
            print("ERROR:  Couldn't find and play sound file")
        }
    }
}
