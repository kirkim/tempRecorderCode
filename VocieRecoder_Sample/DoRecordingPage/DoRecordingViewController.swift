//
//  RecordViewController.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import UIKit
import AVFAudio

class DoRecordingViewController: UIViewController {
    private var recordingSession = AVAudioSession.sharedInstance()
    private let recordManager = RecordManager.shared
    private let recorder = Recorder()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecordAccessManager().handleAccess()
    }
    
    private func attribute() {
        recorder.delegate = self
        // temp
        self.view.backgroundColor = .green
    }
    
    private func layout() {
        [recorder].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        recorder.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        recorder.heightAnchor.constraint(equalToConstant: 200).isActive = true
        recorder.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        recorder.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
}

//MARK: Recorder Delegate 함수
extension DoRecordingViewController: RecordDelegate {
    func tappedSaveButton(didSucceed: Bool) {
        if didSucceed == true {
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "", message: "저장에 실패했습니다.", preferredStyle: .alert)
            self.present(alert, animated: true)
        }
    }
}
