//
//  Config.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/28.
//

import Foundation

class Config {
    static func getRecordFilePath() -> URL {
        let docDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDirURL.appendingPathComponent("record.m4a")
        return filePath
    }
}
