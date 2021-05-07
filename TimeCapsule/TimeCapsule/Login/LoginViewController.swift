//
//  LoginViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {
    
    let dataManager = UserDataManager()
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    @IBOutlet weak var rocketIcon: UIImageView!
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func appleloginButtonTapped(_ sender:Any) {
        dataManager.appleLogin(viewController: self)
    }
    
    @IBAction func kakaologinButtonTapped(_ sender: Any) {
        dataManager.kakaoLogin(viewController: self)
    }
    
    func goToNickname(token: String) {
        fadeoutAnimate()
        let vc = NicknameViewController()
        vc.accessToken = token
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    func userExisted() {
        if let _ = keychain.get(Keys.rocketExists) {
            let mainVC = MainViewController()
            let vc = UINavigationController(rootViewController: mainVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            let introVC = IntroViewController()
            let vc = UINavigationController(rootViewController: introVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    fileprivate func fadeoutAnimate() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.rocketIcon.alpha = 0
            self.appIcon.alpha = 0
            self.descLabel.alpha = 0
            self.appleLoginButton.alpha = 0
            self.kakaoLoginButton.alpha = 0
        }.startAnimation()
    }
}

extension LoginViewController: BacktoLoginDelegate {
    func fadeinAnimate() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.rocketIcon.alpha = 1
            self.appIcon.alpha = 1
            self.descLabel.alpha = 1
            self.appleLoginButton.alpha = 1
            self.kakaoLoginButton.alpha = 1
        }.startAnimation()
    }
}

protocol BacktoLoginDelegate {
    func fadeinAnimate()
}
