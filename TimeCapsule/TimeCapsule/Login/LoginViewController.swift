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
        //dataManager.appleLogin(viewController: self)
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func userExisted(rocketStatus: Int) {
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
            // Create an account in your system
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("userIdentifier: \(userIdentifier)")
            print("fullName: \(String(describing: fullName))")
            print("email: \(String(describing: email))")
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authString = String(data: authorizationCode, encoding: .utf8),
               let tokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authString: \(authString)")
                print("tokenString: \(tokenString)")
            }
        
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("username: \(username)")
            print("password: \(password)")
            
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
