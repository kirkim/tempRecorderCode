//
//  RecordDataSource.swift
//  VocieRecoder_Sample
//
//  Created by 김기림 on 2022/07/01.
//

import Foundation
import UIKit

class RecordListModel {
    private var cellData: [String] = []
    private let networkManager = RecordNetworkManager()
    private let playListDBManager = RecordPlaylistDB()
    
    func getCellData(_ indexPath: IndexPath) -> String {
        return cellData[indexPath.row]
    }
    
    func getCellTotalCount() -> Int {
        return cellData.count
    }
    
    func update(completion: (() -> ())? = nil) {
        networkManager.getRecordList { [weak self] data in
            guard let data = data else { return }
            let frontList = self?.playListDBManager.getData().filter { data.contains($0) }
            let backList = data.filter { frontList?.contains($0) == false }

            self?.cellData = (frontList ?? []) + backList
            self?.playListDBManager.update(playList: self?.cellData ?? [])
            completion?()
        }
    }
    
    func deleteCell(_ indexPath: IndexPath, completion: @escaping () -> ()) {
        let filename = cellData[indexPath.row]
        networkManager.deleteRecord(filename: filename) { isDeleted in
            if (isDeleted == true) {
                self.cellData = self.cellData.filter { $0 != filename }
                    completion()
            } else {
                
            }
        }
    }
    
    func swapByPress(with sender: UILongPressGestureRecognizer, to tableView: UITableView) {
        print("call swapByPress function!")
        let p = sender.location(in: tableView)

        guard let indexPath = tableView.indexPathForRow(at: p) else {
            print("fail to find indexPath!")
            return
        }
        print("Long press at item: \(indexPath.row)")
        
        struct BeforeIndexPath {
            static var value: IndexPath?
        }
        
        switch sender.state {
        case .began:
            BeforeIndexPath.value = indexPath
        case .changed:
            if let beforeIndexPath = BeforeIndexPath.value, beforeIndexPath != indexPath {
                let beforeValue = cellData[beforeIndexPath.row]
                let afterValue = cellData[indexPath.row]
                cellData[beforeIndexPath.row] = afterValue
                cellData[indexPath.row] = beforeValue
                tableView.moveRow(at: beforeIndexPath, to: indexPath)
                playListDBManager.update(playList: cellData)
                
                BeforeIndexPath.value = indexPath
            }
        default:
            // TODO animation
            break
        }
    }
}
