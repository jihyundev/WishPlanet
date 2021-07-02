//
//  MyRocketViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import UIKit

class MyRocketViewController: UIViewController {
    
    var currentRocket: MyRocket?
    var launchedRockets: [MyRocket] = []
    
    let currentCell = CurrentTableViewCell()
    let launchedCell = LaunchedTableViewCell()
    
    let dataManager = MyRocketDataManager()
    let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter
    }()

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
    
    func didRetrieveRocketData(current: MyRocket, launched: [MyRocket]) {
        self.currentRocket = current
        self.launchedRockets = launched
        tableView.reloadData()
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }

}

extension MyRocketViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentRocket == nil {
            tableView.setEmptyRocketView()
            return 0
        } else {
            tableView.restoreWithLine()
            if section == 0 {
                return 1
            } else {
                return launchedRockets.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let rocket = currentRocket {
                let cell = tableView.dequeueReusableCell(withIdentifier: currentCell.cellID) as! CurrentTableViewCell
                cell.rocketID = currentRocket?.rocketID
                cell.date = currentRocket?.period
                cell.delegate = self
                cell.rocketImageView.image = UIImage(named: "icon rocket_\(rocket.color)")
                cell.nameLabel.text = rocket.name
                cell.periodLabel.text = "~\(rocket.period)"
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: launchedCell.cellID) as! LaunchedTableViewCell
            let rocket = launchedRockets[indexPath.row]
            cell.rocketImageView.image = UIImage(named: "icon rocket_\(rocket.color)")
            cell.nameLabel.text = rocket.name
            cell.periodLabel.text = "~\(rocket.period)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let date = currentRocket?.period {
                self.moveToEditVC(title: "진행 중", rocketID: currentRocket?.rocketID ?? 0, date: date)
            } else {
                let date = dateformatter.string(from: Date())
                self.moveToEditVC(title: "진행 중", rocketID: currentRocket?.rocketID ?? 0, date: date)
            }
            
        } else {
            self.navigationController?.popToRootViewController(animated: true)
            
            // delegate 통해 해당 우주선 스크롤뷰 위치로 이동하기
            //
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if currentRocket == nil {
            return 0
        } else {
            if section == 0 {
                return 30
            } else {
                return 44
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if currentRocket == nil {
            return 0
        } else {
            if section == 0 {
                return 12
            } else {
                return 0
            }
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
        view.backgroundColor = UIColor.init(hex: 0x743EE9)
        return view
    }
}

extension MyRocketViewController: MovetoEditRocketDelegate {
    func moveToEditVC(title: String, rocketID: Int, date: String) {
        let vc = MyRocketEditViewController(titleString: title, rocketID: rocketID, originalDate: date)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MyRocketViewController: ReloadRocketDetailDelegate {
    func reloadData() {
        dataManager.getRocket(viewController: self)
    }
}

protocol MovetoEditRocketDelegate: AnyObject {
    func moveToEditVC(title: String, rocketID: Int, date: String)
}

protocol ReloadRocketDetailDelegate: AnyObject {
    func reloadData()
}
