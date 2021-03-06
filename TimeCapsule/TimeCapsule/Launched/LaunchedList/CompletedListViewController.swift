//
//  CompletedListViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/04/18.
//

import UIKit
import PanModal

class CompletedListViewController: UIViewController {
    
    private let rocketID: Int
    private let dataManager = ListDataManager()
    
    private var stoneCount: Int = 0
    private var finishedStoneCount: Int = 0
    private var stoneList: [StoneList] = []
    
    @IBOutlet weak var countLabel: UILabel! // 소원석 개수 카운트
    @IBOutlet weak var finishedCountLabel: UILabel! // 완료한 소원석 개수 카운트
    @IBOutlet weak var tableView: UITableView!
    
    init(rocketID: Int) {
        self.rocketID = rocketID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dataManager.getStones(rocketID: rocketID, viewController: self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: UncheckedListCell.identifier, bundle: nil), forCellReuseIdentifier: UncheckedListCell.identifier)
        tableView.register(UINib(nibName: CheckedListCell.identifier, bundle: nil), forCellReuseIdentifier: CheckedListCell.identifier)
    }
    
    private func setupUI() {
        countLabel.text = ""
        finishedCountLabel.text = ""
        tableView.backgroundColor = .mainPurple
        tableView.rowHeight = 88
        tableView.separatorStyle = .none
    }
    
    // 소원석 목록 조회 성공
    func didRetrieveData(stoneCount: Int, finishedStoneCount: Int, stoneList: [StoneList]) {
        self.stoneCount = stoneCount
        countLabel.text = "총 \(stoneCount)개"
        
        self.finishedStoneCount = finishedStoneCount
        finishedCountLabel.text = "완료 \(finishedStoneCount)개"
        
        self.stoneList = stoneList
        tableView.reloadData()
        
        if stoneCount == 0 {
            tableView.setEmptyStoneView()
        } else {
            tableView.restoreWithoutLine()
        }
    }
    
    // 소원석 체크 성공
    func successToCheckStone(message: String, isChecked: Bool) {
        self.dismissIndicator()
        if !isChecked {
            self.presentAlert(title: message)
        }
        dataManager.getStones(rocketID: rocketID, viewController: self)
    }
    
    func failedToRequest(message: String) {
        self.dismissIndicator()
        self.presentAlert(title: message)
    }

}
extension CompletedListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stoneCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stone = stoneList[indexPath.row]
        switch stone.wishChecked {
        case true:
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckedListCell.identifier) as? CheckedListCell
            cell?.configure(color: stone.stoneColor, date: stone.createdAt, wish: stone.content)
            return cell ?? UITableViewCell()
        case false:
            let cell = tableView.dequeueReusableCell(withIdentifier: UncheckedListCell.identifier) as? UncheckedListCell
            cell?.configure(color: stone.stoneColor, date: stone.createdAt, wish: stone.content)
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stone = stoneList[indexPath.row]
        print("stone ID: \(stone.stoneID)")
        switch stone.wishChecked {
        case true:
            dataManager.patchStoneCheck(checked: true, rocketID: self.rocketID, stoneID: stone.stoneID, viewController: self)
        case false:
            dataManager.patchStoneCheck(checked: false, rocketID: self.rocketID, stoneID: stone.stoneID, viewController: self)
        }
        self.showIndicator()
    }
    
}
extension CompletedListViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(127)
    }
}
