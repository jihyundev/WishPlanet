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
    private let cellIdentifier = "WishlistCell"
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
        tableView.register(UINib(nibName: "WishlistCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupUI() {
        countLabel.text = ""
        tableView.backgroundColor = .mainPurple
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    func didRetrieveData(stoneCount: Int, stoneList: [StoneList]) {
        self.stoneCount = stoneCount
        countLabel.text = "총 \(stoneCount)개"
        self.stoneList = stoneList
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? WishlistCell
        let stone = stoneList[indexPath.row]
        cell?.stoneImageView.image = UIImage(named: "small_dol_\(stone.stoneColor + 1)")
        cell?.dateLabel.text = stone.createdAt
        cell?.wishLabel.text = stone.content
        return cell ?? UITableViewCell()
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
