//
//  FinishedListViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import UIKit

class FinishedListViewController: UIViewController {
    
    let wishCell = FinishedListCell()
    let dataManager = WishlistDataManager()
    
    var marbleList = [MarbleList]()
    var finishedWishes = ["제주도 가고싶다", "노래방", "그냥돌아다니기", "홍콩여행", "미국도 갈거야"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getFinishedMarbles(viewController: self)
        self.view.backgroundColor = #colorLiteral(red: 0.4529297948, green: 0.2904702425, blue: 1, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "FinishedListCell", bundle: nil), forCellReuseIdentifier: wishCell.cellID)
        tableView.rowHeight = 80
        tableView.backgroundColor = #colorLiteral(red: 0.4529297948, green: 0.2904702425, blue: 1, alpha: 1)
    }
    
    func didRetrieveData() {
        tableView.reloadData()
    }

}
extension FinishedListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marbleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: wishCell.cellID) as! FinishedListCell
        let wish = marbleList[indexPath.row]
        cell.content = wish.content
        cell.dateLabel.text = wish.createdAt
        switch wish.marbleColor {
        case 0:
            cell.stoneImageView.image = UIImage(named: "small_dol_1")
        case 1:
            cell.stoneImageView.image = UIImage(named: "small_dol_2")
        case 2:
            cell.stoneImageView.image = UIImage(named: "small_dol_3")
        case 3:
            cell.stoneImageView.image = UIImage(named: "small_dol_4")
        case 4:
            cell.stoneImageView.image = UIImage(named: "small_dol_5")
        default:
            cell.stoneImageView.image = UIImage(named: "small_dol_1")
        }
        return cell
    }
}
