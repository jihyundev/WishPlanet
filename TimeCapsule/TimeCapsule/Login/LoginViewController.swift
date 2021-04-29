//
//  LoginViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import UIKit

class LoginViewController: UIViewController {
    
    let dataManager = UserDataManager()
    
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 8
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        dataManager.kakaoLogin(viewController: self)
    }
    
    @IBAction func nicknameButtonTapped(_ sender: Any) {
        let vc = NicknameViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func goToNickname(token: String) {
        let vc = NicknameViewController()
        vc.accessToken = token
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func userExisted() {
        let mainVC = MainViewController()
        mainVC.modalPresentationStyle = .fullScreen
        self.present(mainVC, animated: true, completion: nil)
    }

}
