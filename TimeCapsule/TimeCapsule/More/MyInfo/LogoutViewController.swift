//
//  LogoutViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import UIKit
import KakaoSDKUser
import KeychainSwift

class LogoutViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    var delegate: ChangeRootDelegate?

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    fileprivate func setupUI() {
        baseView.layer.cornerRadius = 24
        baseView.borderWidth = 4
        baseView.borderColor = .black
        cancelButton.layer.cornerRadius = 12
        proceedButton.layer.cornerRadius = 12
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }

    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func proceedButtonTapped(_ sender: Any) {
        keychain.clear()
        self.dismiss(animated: true) {
            self.delegate?.goToLoginVC()
        }
        
        // TODO: 카카오 로그인 모듈 변경사항 적용한 뒤 UserApi로 로그아웃 재적용
        
        /*
        let socialType = self.keychain.get(Keys.loginType)
        if (socialType == "카카오 로그인") || (socialType == LoginType.kakao.rawValue) {
            // 카카오 API 로그아웃 처리 (토큰 삭제)
            UserApi.shared.logout { error in
                if let error = error {
                    print(error)
                    self.presentAlert(title: "로그아웃에 실패했습니다. ")
                } else {
                    print("kakao logout() success.")
                    self.keychain.clear()
                    self.dismiss(animated: true) {
                        self.delegate?.goToLoginVC()
                    }
                }
            }
        } else {
            // 애플 로그아웃 처리
            keychain.clear()
            self.dismiss(animated: true) {
                self.delegate?.goToLoginVC()
            }
        }
        */
    }
}
