//
//  Recoder.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import UIKit
import AVFAudio

class Recorder: UIStackView {
    private let slideView = UIView()
    private let controllerStackView = RecordControllerStackView()
    private let saveRecordButton = UIButton()
    
    var delegate: RecordDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
        initAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initAction() {
        saveRecordButton.addTarget(self, action: #selector(handleSaveRecordButton), for: .touchUpInside)
    }
    
    @objc private func handleSaveRecordButton() {
        RecordManager.shared.save { [weak self] didSucceed in
            self?.delegate?.tappedSaveButton(didSucceed: didSucceed)
        }
    }
}

//MARK: - attribute, layout 함수
extension Recorder {
    private func attribute() {
        self.axis = .vertical
        self.distribution = .equalSpacing
        
        saveRecordButton.setTitle(" 저장 ", for: .normal)
        
        // temp
        slideView.backgroundColor = .purple
        controllerStackView.backgroundColor = .systemGray4
        saveRecordButton.backgroundColor = .brown
    }
    
    private func layout() {
        [slideView, controllerStackView, saveRecordButton].forEach {
            self.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let slideViewHeightMultiplier = 0.2
        let controllerStackViewHeightMultiplier = 0.3
        let saveRecordButtonHeightMultiplier = 0.2
        
        slideView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: slideViewHeightMultiplier).isActive = true
        controllerStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: controllerStackViewHeightMultiplier).isActive = true
        saveRecordButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: saveRecordButtonHeightMultiplier).isActive = true
    }
}
