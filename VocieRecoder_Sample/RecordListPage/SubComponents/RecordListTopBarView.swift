//
//  RecordListTopBarView.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import UIKit

class RecordListTopBarView: UIView {
    private let titleLabel = UILabel()
    private let addRecordButton = UIButton()
    var rootViewController: UIViewController?
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        
        self.titleLabel.text = title
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        
        addRecordButton.setTitle(" + ", for: .normal)
        addRecordButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        addRecordButton.addTarget(self, action: #selector(handleAddRecordButton), for: .touchUpInside)
    }
    
    @objc private func handleAddRecordButton() {
        let vc = DoRecordingViewController()
        rootViewController?.present(vc, animated: true)
    }
    
    private func layout() {
        [titleLabel, addRecordButton].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addRecordButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
}
