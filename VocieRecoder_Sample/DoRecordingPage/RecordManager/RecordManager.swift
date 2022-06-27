//
//  RecordManager.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import Foundation
import AVFAudio
import AVFoundation

class RecordManager {
    static let shared = RecordManager()
    private init() { }
    private var recordingSession = AVAudioSession.sharedInstance()
    private var recorder: AVAudioRecorder?
//    private var audioPlayer: AVAudioPlayer?
    private var audioPlayManager = AudioPlayerManager.shared
    
    
    func isPlaying() -> Bool {
        return audioPlayManager.isPlaying()
    }
}

// MARK: - action 함수
extension RecordManager {
    func play() {
        print("play")
        do {
//            self.audioPlayer = try AVAudioPlayer(contentsOf: self.getFilePath())
            let item = AVPlayerItem(url: self.getFilePath())
            self.audioPlayManager.replaceCurrentItem(with: item)
            self.audioPlayManager.play()
        } catch {
            print("faild to play file")
        }
    }
    
    func pause() {
        self.audioPlayManager.pause()
    }
    
    func gobackward5seconds() {
        print("goBack5seconds")
    }
    
    func goforward5seconds() {
        print("goforward5seconds")
    }
    
    func record() {
        if (recorder?.isRecording == true) {
            print("stop record!")
            recorder?.stop()
        } else {
            print("start record!")
            recorder?.record()
        }
    }
}

// MARK: - init 함수
extension RecordManager {
    func initRecord() {
        requestRecordAccess { [weak self] isAllowed in
            if isAllowed {
                print("success")
                self?.initRecorder()
            } else {
                print("fail")
            }
        }
    }
    
    private func initRecorder() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try self.recordingSession.setCategory(.playAndRecord)
            try self.recordingSession.overrideOutputAudioPort(.speaker)
            self.recorder = try AVAudioRecorder(url: self.getFilePath(), settings: settings)
        } catch {
            print("fail to init recorder!")
        }
    }
    
    private func requestRecordAccess(completion: @escaping (Bool) -> Void) {
        switch recordingSession.recordPermission {
        case .undetermined:
            recordingSession.requestRecordPermission { isAllowed in
                completion(isAllowed)
            }
        case .denied:
            print("recordPermission denied.")
            //TODO: 직접 설정을 변경창을 여는 alert를 만들기
            completion(false)
        case .granted:
            print("recordPermission granted.")
            completion(true)
        @unknown default:
            fatalError("recordPermission unknown default.")
        }
    }
    
    private func getFilePath() -> URL {
        let docDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDirURL.appendingPathComponent("xx.m4a")
        return filePath
    }
}
