//
//  LoginViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import UIKit
import KeychainSwift
import AuthenticationServices

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
        //self.showIndicator()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func kakaologinButtonTapped(_ sender: Any) {
        //self.showIndicator()
        dataManager.kakaoLogin(viewController: self)
    }
    
    func goToNickname(loginType: LoginType, token: String) {
        //self.dismissIndicator()
        fadeoutAnimate()
        let vc = NicknameViewController(loginType: loginType, accessToken: token)
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func userExisted(rocketStatus: Int) {
        //self.dismissIndicator()
        switch rocketStatus {
        case 1:
            // 로켓이 하나도 없는 상태 (신규회원)
            print("로켓이 하나도 없는 상태 (신규회원)")
            let introVC = IntroViewController(flag: 0)
            let vc = UINavigationController(rootViewController: introVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case 2:
            // 로켓 존재, 발사되지 않은 상태
            print("로켓 존재, 발사되지 않은 상태")
            let mainVC = MainViewController()
            let vc = UINavigationController(rootViewController: mainVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case 3:
            // 로켓 존재, 발사된 상태
            print("로켓 존재, 발사된 상태")
            let introVC = IntroViewController(flag: 1)
            let vc = UINavigationController(rootViewController: introVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        default:
            return
        }
    }
    
    fileprivate func fadeoutAnimate() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [weak self] in
            [self?.rocketIcon, self?.appIcon, self?.descLabel, self?.appleLoginButton, self?.kakaoLoginButton].forEach {
                $0?.alpha = 0
            }
        }.startAnimation()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print("ASAuthorizationAppleIDCredential")
            // Create an account in your system
            let userIdentifier = appleIDCredential.user
            keychain.set(userIdentifier, forKey: Keys.userIdentifier)
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               //let authString = String(data: authorizationCode, encoding: .utf8),
               let tokenString = String(data: identityToken, encoding: .utf8) {
                dataManager.verifyUser(loginType: .apple, accessToken: tokenString, viewController: self)
            }
        
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("ASPasswordCredential login")
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("--login err")
    }
}

extension LoginViewController: BacktoLoginDelegate {
    func fadeinAnimate() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [weak self] in
            [self?.rocketIcon, self?.appIcon, self?.descLabel, self?.appleLoginButton, self?.kakaoLoginButton].forEach {
                $0?.alpha = 1
            }
        }.startAnimation()
    }
}

protocol BacktoLoginDelegate {
    func fadeinAnimate()
}
