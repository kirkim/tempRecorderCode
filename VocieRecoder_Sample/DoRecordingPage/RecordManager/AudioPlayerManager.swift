//
//  AudioPlayerManager.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import Foundation
import AVFoundation

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    private init() { }
    private var player = AVPlayer()
    
    func isPlaying() -> Bool {
        return player.isPlaying
    }
    
    func replaceCurrentItem(with item: AVPlayerItem?) {
        player.replaceCurrentItem(with: item)
    }
    
    func pause() {
        player.pause()
    }
    
    func play() {
        player.play()
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
