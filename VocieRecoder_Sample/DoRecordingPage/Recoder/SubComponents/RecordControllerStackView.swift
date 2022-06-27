//
//  ControllerStackView.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import UIKit
import AVFAudio

class RecordControllerStackView: UIStackView {
    private let playButton = UIButton()
    private let gobackward5secondsButton = UIButton()
    private let goforward5secondsButton = UIButton()
    private let recordButton = UIButton()
    private let manager: RecordManager
    
    init(_ recordManager: RecordManager = .shared) {
        self.manager = recordManager
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
        initButtonHandler()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Action 함수
extension RecordControllerStackView {
    private func initButtonHandler() {
        playButton.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
        gobackward5secondsButton.addTarget(self, action: #selector(handleGobackward5secondsButton), for: .touchUpInside)
        goforward5secondsButton.addTarget(self, action: #selector(handleGoforward5secondsButton), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(handleRecordButton), for: .touchUpInside)
    }
    
    @objc private func handlePlayButton() {
        print(manager.isPlaying())
        if (manager.isPlaying()) {
            playButton.setImage(UIImage(systemName: "play"), for: .normal)
            manager.pause()
        } else {
            playButton.setImage(UIImage(systemName: "pause"), for: .normal)
            manager.play()
        }
    }
    
    @objc private func handleGobackward5secondsButton() {
        manager.gobackward5seconds()
    }
    
    @objc private func handleGoforward5secondsButton() {
        manager.goforward5seconds()
    }
    
    @objc private func handleRecordButton() {
        manager.record()
    }
}

//MARK: - attribute, layout 함수
extension RecordControllerStackView {
    private func attribute() {
        self.axis = .horizontal
        self.distribution = .equalSpacing
        
        playButton.setImage(UIImage(systemName: "play"), for: .normal)
        gobackward5secondsButton.setImage(UIImage(systemName: "gobackward.5"), for: .normal)
        goforward5secondsButton.setImage(UIImage(systemName: "goforward.5"), for: .normal)
        recordButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        
        [recordButton, playButton, gobackward5secondsButton, goforward5secondsButton].forEach {
            $0.tintColor = .black
            $0.imageView?.contentMode = .scaleAspectFit
            $0.backgroundColor = .blue
        }
        recordButton.tintColor = .systemRed
    }
    
    private func layout() {
        let leftPadding = UIView()
        let rightPadding = UIView()
        
        [leftPadding, recordButton, gobackward5secondsButton, playButton,goforward5secondsButton, rightPadding].forEach {
            self.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
}
