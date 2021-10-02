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
    let dataManager = MyInfoDataManager()
    let infoCell = MyInfoTableViewCell()
    
    var name: String?
    var delegate: ReloadNicknameDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "내 정보"
        
        setupUI()
        dataManager.getNickname(viewController: self)
        
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
    
    func didRetrieveData(nickname: String) {
        name = nickname
        tableView.reloadData()
    }
}

extension MyInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell.cellID) as? MyInfoTableViewCell
            cell?.configure(main: "닉네임 수정", sub: self.name, color: .white)
            return cell ?? UITableViewCell()
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell.cellID) as? MyInfoTableViewCell
            cell?.configure(main: "개인정보 처리방침", sub: nil, color: .white)
            return cell ?? UITableViewCell()
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell.cellID) as? MyInfoTableViewCell
            cell?.configure(main: "로그아웃", sub: nil, color: .white)
            return cell ?? UITableViewCell()
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell.cellID) as? MyInfoTableViewCell
            cell?.configure(main: "탈퇴하기", sub: nil, color: .darkPurple)
            return cell ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = NicknameEditViewController()
            vc.title = "닉네임 수정"
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = PrivacyPolicyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            print("로그아웃")
            let vc = LogoutViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
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
    func updateNickname() {
        print("MyInfoViewController - updateNickname() called")
        dataManager.getNickname(viewController: self)
        delegate?.updateNickname()
    }
}

protocol ChangeRootDelegate {
    func goToLoginVC()
}

protocol ReloadNicknameDelegate {
    func updateNickname()
}
