//
//  MainViewController.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/27.
//

import UIKit

class RecordListViewController: UIViewController {
    private let topBarView = RecordListTopBarView(title: "Voice Memos")
    private let tableView = UITableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.view.backgroundColor = .white
        
        // temp
        topBarView.backgroundColor = .purple
        topBarView.rootViewController = self
        tableView.backgroundColor = .systemPink
    }
    
    private func layout() {
        [topBarView, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let topBarViewHeight = 50.0
        
        topBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        topBarView.heightAnchor.constraint(equalToConstant: topBarViewHeight).isActive = true
        
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 30).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
