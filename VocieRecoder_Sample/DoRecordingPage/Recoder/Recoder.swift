//
//  Recoder.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import UIKit
import AVFAudio

class Recoder: UIStackView {
    private let slideView = UIView()
    private let controllerStackView = RecordControllerStackView()
    
    init() {
        super.init(frame: CGRect.zero)
        
        attribute()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - attribute, layout 함수
extension Recoder {
    private func attribute() {
        self.axis = .vertical
        self.distribution = .equalSpacing
        
        // temp
        slideView.backgroundColor = .purple
        controllerStackView.backgroundColor = .systemGray4
    }
    
    private func layout() {
        [slideView, controllerStackView].forEach {
            self.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let slideViewHeightMultiplier = 0.3
        let controllerStackViewHeightMultiplier = 0.5
        
        slideView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: slideViewHeightMultiplier).isActive = true
        controllerStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: controllerStackViewHeightMultiplier).isActive = true
    }
}
