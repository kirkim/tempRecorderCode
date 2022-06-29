//
//  RecordManager.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import Foundation
import AVFAudio
import AVFoundation
import FirebaseStorage

class RecordManager {
    static let shared = RecordManager()
    private init() { }
    
    private var recorder: AVAudioRecorder?
    private let audioPlayManager = AudioPlayerManager.shared
    private let networkManager = RecordNetworkManager()

    func isPlaying() -> Bool {
        return audioPlayManager.isPlaying()
    }
}

// MARK: - action 함수
extension RecordManager {
    func play() {
        print("play")
        let item = AVPlayerItem(url: Config.getRecordFilePath())
        self.audioPlayManager.replaceCurrentItem(with: item)
        self.audioPlayManager.play()
    }
    
    func pause() {
        self.audioPlayManager.pause()
    }
    
    func record() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        if (recorder?.isRecording == true) {
            print("stop record!")
            recorder?.stop()
        } else {
            do {
                self.recorder = try AVAudioRecorder(url: Config.getRecordFilePath(), settings: settings)
                print("start record!")
                recorder?.record()
            } catch {
                print("record fail: ", error)
            }
        }
    }
    
    func save(completion: @escaping (Bool) -> ()) {
        //TODO: 현재날짜로 파일명 만들기 [x]
        networkManager.saveRecord(filename: "haha", completion: completion)
    }
}
