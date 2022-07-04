//
//  RecordListVeiwController.swift
//  VoiceRecorder
//
//  Created by 김기림 on 2022/06/29.
//

import UIKit

class RecordListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = RecordListViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
        setRefresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.update {
            self.tableView.reloadData()
        }
    }
    
    private func attribute() {
        title = "Voice Memos"
        view.backgroundColor = .white
        
        AddNavigationbarRightItem()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RecordListCell.self, forCellReuseIdentifier: RecordListCell.identifier)
        tableView.reloadData()
        tableView.backgroundColor = .systemPink
    }
    
    private func AddNavigationbarRightItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentRecordPage))
        self.navigationItem.rightBarButtonItems = [addButton]
    }
    
    @objc private func presentRecordPage() {
        let vc = RecordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func layout() {
        [tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate 메서드
extension RecordListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCellTotalCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordListCell.identifier, for: indexPath) as? RecordListCell else {
            return UITableViewCell()
        }
        cell.setData(filename: viewModel.getCellData(indexPath))
        cell.addTapGesture(action: handleLongPress(with:_:))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteCell(indexPath) {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = viewModel.getCellData(indexPath)
        let vc = PlayerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - 테이블뷰를 당겼을 때 새로고침시키는 메서드
extension RecordListViewController {
    private func setRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        self.viewModel.update(completion: {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}

//MARK: - 셀이동 이벤트
extension RecordListViewController {
    private func handleLongPress(with sender: UILongPressGestureRecognizer, _ toCenterPoint: CGPoint) {
        swapByPress(with: sender, toCenterPoint: toCenterPoint)
    }
    
    func swapByPress(with sender: UILongPressGestureRecognizer, toCenterPoint: CGPoint) {
        var longPressedPoint = sender.location(in: tableView)
//        print("long: ", longPressedPoint, "toCenterPoint: ", toCenterPoint)
        
        longPressedPoint.x = longPressedPoint.x <= 0 ? 0 : longPressedPoint.x
        longPressedPoint.x = longPressedPoint.x >= tableView.frame.width-1 ? tableView.frame.width-1 : longPressedPoint.x
        longPressedPoint.y = longPressedPoint.y <= 0 ? 0 : longPressedPoint.y
        longPressedPoint.y = longPressedPoint.y >= tableView.frame.height ? tableView.frame.height : longPressedPoint.y
        
        guard let indexPath = tableView.indexPathForRow(at: longPressedPoint) else {
            viewModel.failToFindIndexPath()
            return
        }

        longPressedPoint.x -= ToCenterPoint.value?.x ?? 0.0
        longPressedPoint.y += ToCenterPoint.value?.y ?? 0.0
        
        struct ToCenterPoint {
            static var value: CGPoint?
        }
        
        struct BeforeIndexPath {
            static var value: IndexPath?
        }
        
        struct CellSnapshotView {
            static var value: UIView?
        }
        
        switch sender.state {
        case .began:
            BeforeIndexPath.value = indexPath
            
            ToCenterPoint.value = CGPoint(x: toCenterPoint.x, y: toCenterPoint.y)
            longPressedPoint.x -= ToCenterPoint.value?.x ?? 0.0
            longPressedPoint.y += ToCenterPoint.value?.y ?? 0.0
            tableView.isEditing = false
            // snapshot을 tableView에 추가
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            CellSnapshotView.value = cell.snapshotCellStyle()
            CellSnapshotView.value?.center = cell.center
            CellSnapshotView.value?.alpha = 0.0
            if let cellSnapshotView = CellSnapshotView.value {
                tableView.addSubview(cellSnapshotView)
            }
            
            // 원래의 cell을 hidden시키고 snapshot이 보이도록 설정
            UIView.animate(withDuration: 0.3) {
                CellSnapshotView.value?.center = longPressedPoint
                CellSnapshotView.value?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                CellSnapshotView.value?.alpha = 0.98
                cell.alpha = 0.0
            } completion: { (isFinish) in
                if isFinish {
                    cell.isHidden = true
                }
            }
        case .changed:
            CellSnapshotView.value?.center = longPressedPoint
            
            if let beforeIndexPath = BeforeIndexPath.value, beforeIndexPath != indexPath {
                viewModel.swapCell(beforeIndexPath.row, indexPath.row)
                tableView.moveRow(at: beforeIndexPath, to: indexPath)
                
                BeforeIndexPath.value = indexPath
            }
        case .ended:
            viewModel.endTapped()
            // 손가락을 떼면 indexPath에 셀이 나타나는 애니메이션
            guard let beforeIndexPath = BeforeIndexPath.value,
                  let cell = tableView.cellForRow(at: beforeIndexPath) else { return }
            cell.isHidden = false
            cell.alpha = 0.0
            
            // Snapshot이 사라지고 셀이 나타내는 애니메이션 부여
            UIView.animate(withDuration: 0.3) {
                CellSnapshotView.value?.center = cell.center
                CellSnapshotView.value?.transform = CGAffineTransform.identity
                CellSnapshotView.value?.alpha = 1.0
                cell.alpha = 1.0
            } completion: { (isFinish) in
                if isFinish {
                    BeforeIndexPath.value = nil
                    CellSnapshotView.value?.removeFromSuperview()
                    CellSnapshotView.value = nil
                    ToCenterPoint.value = nil
                }
            }
        default:
            // TODO: animation
            break
        }
    }
}
