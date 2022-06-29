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
    
    func gobackward5seconds() {
        //TODO: 5초 앞으로 당기기 기능 구현하기 [x]
        print("goBack5seconds")
    }
    
    func goforward5seconds() {
        //TODO: 5초 뒤로 당기기 기능 구현하기 [x]
        print("goforward5seconds")
    }
    
    func currentTime() {
        
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
