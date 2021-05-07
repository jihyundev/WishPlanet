//
//  MyInfoViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import UIKit
import KeychainSwift

class MyInfoViewController: UIViewController {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let infoCell = MyInfoTableViewCell()
    var name: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "내 정보"
        
        setupUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MyInfoTableViewCell", bundle: nil), forCellReuseIdentifier: infoCell.cellID)
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = .mainPurple
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .dividePurple
        tableView.backgroundColor = .mainPurple
        tableView.tableFooterView = UIView()
    }
}

extension MyInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell.cellID) as! MyInfoTableViewCell
            cell.mainLabel.text = "닉네임 수정"
            let nickname = keychain.get(Keys.nickname)
            cell.subLabel.text = nickname
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell.cellID) as! MyInfoTableViewCell
            cell.mainLabel.text = "개인정보 처리방침"
            cell.subLabel.isHidden = true
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell.cellID) as! MyInfoTableViewCell
            cell.mainLabel.text = "로그아웃"
            cell.subLabel.isHidden = true
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell.cellID) as! MyInfoTableViewCell
            cell.mainLabel.text = "탈퇴하기"
            cell.mainLabel.textColor = #colorLiteral(red: 0.4237937331, green: 0.1606132686, blue: 0.8150677085, alpha: 1)
            cell.subLabel.isHidden = true
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = NicknameEditViewController()
            vc.title = "닉네임 수정"
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = PrivacyPolicyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            print("로그아웃")
            let vc = LogoutViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        case 3:
            print("탈퇴하기")
            let vc = LeaveViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print()
        }
    }
}

extension MyInfoViewController: ChangeRootDelegate {
    func goToLoginVC() {
        let loginVC = LoginViewController()
        self.navigationController?.changeRootViewController(loginVC)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension MyInfoViewController: ReloadNicknameDelegate {
    func reloadNicknameRow() {
        let index = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: [index], with: .none)
    }
}

protocol ChangeRootDelegate {
    func goToLoginVC()
}

protocol ReloadNicknameDelegate {
    func reloadNicknameRow()
}
