//
//  FireBaseStorageManager.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/06/28.
//

import Foundation
import FirebaseStorage

struct RecordNetworkManager {
    let storageRef = Storage.storage().reference().child("record")
    
    func saveRecord(filename: String, completion: ((Bool) -> ())? = nil) {
        let localRecordFileURL = Config.getRecordFilePath()
        
        let recordRef = storageRef.child(filename)
        
        do {
            let data = try Data(contentsOf: localRecordFileURL)
            DispatchQueue.global().async {
                recordRef.putData(data, metadata: nil) { metadata, error in
                    guard error != nil,
                          let metadata = metadata else {
                        print("fail")
                        DispatchQueue.main.async {
                            completion?(false)
                        }
                        return
                    }
                    print("success!", metadata)
                    DispatchQueue.main.async {
                        completion?(true)
                    }
                }
            }
        } catch {
            print("error!")
            completion?(false)
        }
    }
    
    func getRecordData(filename: String, completion: ((Data?) -> ())? = nil) {
        let recordRef = storageRef.child(filename)
        DispatchQueue.global().async {
            recordRef.getData(maxSize: 1000000) { data, error in
                if let error = error {
                    print("download error: ", error)
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                } else {
                    print("success download data!")
                    DispatchQueue.main.async {
                        completion?(data)
                    }
                }
            }
        }
        
    }
    
    func getRecordMetaData(filename: String, completion: ((StorageMetadata?) -> ())? = nil) {
        let recordRef = storageRef.child(filename)
        
        DispatchQueue.global().async {
            recordRef.getMetadata { metadata, error in
                if let error = error {
                    print("download error: ", error)
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                } else {
                    print("success download metaData!")
                    DispatchQueue.main.async {
                        completion?(metadata)
                    }
                }
            }
        }
    }
    
    func getRecordList(completion: (([String]?) -> ())? = nil) {
        DispatchQueue.global().async {
            storageRef.listAll { data, error in
                if let error = error {
                    print("load list error!", error)
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                    return
                }
                guard let data = data else {
                    print("no data!")
                    DispatchQueue.main.async {
                        completion?([])
                    }
                    return
                }
                //MARK: Prefix가 뭐지?
                for prefix in data.prefixes {
                    print(prefix)
                }
                
                let result = data.items.map { $0.name }
                DispatchQueue.main.async {
                    completion?(result)
                }
            }
        }
    }
    
    func deleteRecord(filename: String, completion: ((Bool) -> ())? = nil) {
        let recordRef = storageRef.child(filename)
        DispatchQueue.global().async {
            recordRef.delete { error in
                if let error = error {
                    print("delete error!", error)
                    DispatchQueue.main.async {
                        completion?(false)
                    }
                } else {
                    print("success delete file!")
                    DispatchQueue.main.async {
                        completion?(true)
                    }
                }
            }
        }
    }
}
