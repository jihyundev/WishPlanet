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
    private let uncheckedCellID = "UncheckedListCell"
    private let checkedCellID = "CheckedListCell"
    private let dataManager = ListDataManager()
    
    var stoneCount: Int = 0
    var stoneList: [StoneList] = []
    
    @IBOutlet weak var countLabel: UILabel! // 소원석 개수 카운트
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
        tableView.register(UINib(nibName: "UncheckedListCell", bundle: nil), forCellReuseIdentifier: uncheckedCellID)
        tableView.register(UINib(nibName: "CheckedListCell", bundle: nil), forCellReuseIdentifier: checkedCellID)
    }
    
    private func setupUI() {
        countLabel.text = ""
        tableView.backgroundColor = .mainPurple
        tableView.rowHeight = 88
        tableView.separatorStyle = .none
    }
    
    // 소원석 목록 조회 성공
    func didRetrieveData(stoneCount: Int, stoneList: [StoneList]) {
        self.stoneCount = stoneCount
        countLabel.text = "총 \(stoneCount)개"
        self.stoneList = stoneList
        tableView.reloadData()
    }
    
    // 소원석 체크 성공
    func successToCheckStone() {
        dataManager.getStones(rocketID: rocketID, viewController: self)
    }
    
    func failedToRequest(message: String) {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: checkedCellID) as? CheckedListCell
            cell?.stoneImageView.image = UIImage(named: "small_dol_\(stone.stoneColor + 1)")
            cell?.dateLabel.text = stone.createdAt
            cell?.wishLabel.text = stone.content
            return cell ?? UITableViewCell()
        case false:
            let cell = tableView.dequeueReusableCell(withIdentifier: uncheckedCellID) as? UncheckedListCell
            cell?.stoneImageView.image = UIImage(named: "small_dol_\(stone.stoneColor + 1)")
            cell?.dateLabel.text = stone.createdAt
            cell?.wishLabel.text = stone.content
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stone = stoneList[indexPath.row]
        print("stone ID: \(stone.stoneID)")
        dataManager.patchStoneCheck(rocketID: self.rocketID, stoneID: stone.stoneID, viewController: self)
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
