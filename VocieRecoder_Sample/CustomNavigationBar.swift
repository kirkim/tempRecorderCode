//
//  CustomNavigationBar.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/29.
//

import UIKit

class CustomNavigationBar: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        attribute()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.navigationBar.topItem?.backButtonTitle = ""
        self.navigationBar.tintColor = .black
    }
}
