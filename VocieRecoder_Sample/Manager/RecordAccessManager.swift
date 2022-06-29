//
//  recordAccessManager.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/28.
//

import Foundation
import AVFoundation
import AVFAudio

class RecordAccessManager {
    private let recordingSession = AVAudioSession.sharedInstance()
    
    func handleAccess() {
        requestRecordAccess { [weak self] isAllowed in
            if isAllowed {
                self?.initRecorder()
            } else {
            }
        }
    }
    
    private func initRecorder() {
        do {
            try self.recordingSession.setCategory(.playAndRecord)
            try self.recordingSession.overrideOutputAudioPort(.speaker)
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
}
