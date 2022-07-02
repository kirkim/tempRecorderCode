//
//  RecordPlaylistDBManager.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/07/02.
//

import Foundation

class RecordPlaylistDB {
    private let userDefaults = UserDefaults(suiteName: "playList")
    
    func update(playList: [String]) {
        userDefaults?.setValue(playList, forKey: "playList")
    }
    
    func getData() -> [String] {
        guard let savedData = userDefaults?.object(forKey: "playList") as? [String] else { return [] }
        return savedData
    }
    
}
