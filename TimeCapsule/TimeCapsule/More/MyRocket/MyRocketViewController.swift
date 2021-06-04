//
//  MyRocketViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import UIKit

class MyRocketViewController: UIViewController {
    
    // UI 테스트용
    var currentRocket = MyRocket(name: "워니의 로케토", period: "21.10.29", color: 0)
    var launchedRockets = [
        MyRocket(name: "꽃향기를 맡으면 붕붕붕", period: "20.11.08", color: 1),
        MyRocket(name: "뤰보르-파퓨아뉴기니", period: "19.12.25", color: 3)
    ]
    
    let currentCell = CurrentTableViewCell()
    let launchedCell = LaunchedTableViewCell()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "내 우주선 관리"
        self.view.backgroundColor = .mainPurple
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "CurrentTableViewCell", bundle: nil), forCellReuseIdentifier: currentCell.cellID)
        tableView.register(UINib(nibName: "LaunchedTableViewCell", bundle: nil), forCellReuseIdentifier: launchedCell.cellID)
        tableView.rowHeight = 100
        tableView.backgroundColor = .mainPurple
        tableView.tableFooterView = UIView()
    }

}

extension MyRocketViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return launchedRockets.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: currentCell.cellID) as! CurrentTableViewCell
            cell.rocketImageView.image = UIImage(named: "icon rocket_\(currentRocket.color)")
            cell.nameLabel.text = currentRocket.name
            cell.periodLabel.text = "~\(currentRocket.period)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: launchedCell.cellID) as! LaunchedTableViewCell
            let rocket = launchedRockets[indexPath.row]
            cell.rocketImageView.image = UIImage(named: "icon rocket_\(rocket.color)")
            cell.nameLabel.text = rocket.name
            cell.periodLabel.text = "~\(rocket.period)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 12
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
            view.backgroundColor = .mainPurple
            
            let label = UILabel(frame: CGRect(x: 22, y: 5, width: view.frame.size.width, height: view.frame.size.height))
            view.addSubview(label)
            label.text = "진행 중"
            label.textColor = .white
            label.font = UIFont.SpoqaHanSansNeo(.medium, size: 13)
            
            return view
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
            view.backgroundColor = .mainPurple
            
            let label = UILabel(frame: CGRect(x: 22, y: 15, width: view.frame.size.width, height: view.frame.size.height))
            view.addSubview(label)
            label.text = "발사 완료"
            label.textColor = .white
            label.font = UIFont.SpoqaHanSansNeo(.medium, size: 13)
            
            let countLabel = UILabel(frame: CGRect(x: 77, y: 15, width: 20, height: view.frame.size.height))
            view.addSubview(countLabel)
            countLabel.text = "\(launchedRockets.count)대"
            countLabel.textColor = .init(white: 1.0, alpha: 0.5)
            countLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 13)
            
            return view
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4958559275, green: 0.1930817962, blue: 0.9492445588, alpha: 1)
        return view
    }
}
