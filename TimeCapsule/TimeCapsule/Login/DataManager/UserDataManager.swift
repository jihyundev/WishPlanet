//
//  loginDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import Foundation
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import KeychainSwift

class UserDataManager {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    func appleLogin(viewController: LoginViewController) {
        print("appleLogin() called")
    }
    
    func kakaoLogin(viewController: LoginViewController) {
        // 카카오톡 설치 여부 확인
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달
            AuthApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    // do something
                    _ = oauthToken
                    let accessToken = oauthToken?.accessToken
                    self.verifyUser(accessToken: accessToken!, viewController: viewController)
                }
            }
        } else {
            // 카카오톡이 기기에 설치되지 않았을 경우 - 웹 브라우저를 통한 로그인
            AuthApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    
                    // do something
                    _ = oauthToken
                    // Access Token
                    let accessToken = oauthToken?.accessToken
                    UserApi.shared.me() { (user, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print("me() success.")
                            
                            // do something
                            _ = user
                            if user?.id != nil {
                                self.verifyUser(accessToken: accessToken!, viewController: viewController)
                            }
                        }
                    }
                }
            }
        }
    }
    // 가입 회원 여부 검사
    func verifyUser(accessToken: String, viewController: LoginViewController) {
        print("verifyUser() called")
        let url = URLType.userExists.makeURL
        let headers: HTTPHeaders = ["social-token": accessToken]
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseString { response in
            switch response.result {
            case .success(let response):
                if response == "true" {
                    // 이미 가입된 회원
                    print("이미 가입된 회원입니다. ")
                    self.login(accessToken: accessToken, viewController: viewController)
                    
                } else {
                    // 회원가입 진행 전 닉네임 설정
                    viewController.goToNickname(token: accessToken)
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다. ", isCancelActionIncluded: false)
                }
            }
        }
    }
    
    // 로그인 (JWT 토큰 발급)
    func login(accessToken: String, viewController: LoginViewController) {
        print("login() called")
        let url = URLType.userLogin.makeURL
        let headers: HTTPHeaders = ["social-token": accessToken]
        AF.request(url, method: .post, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseString { response in
            switch response.result {
            case .success(let response):
                let jwtToken = response
                print("token: \(jwtToken)")
                
                print("login type: kakao")
                self.keychain.set(jwtToken, forKey: Keys.token)
                self.keychain.set("카카오 로그인", forKey: Keys.loginType)
                
                // 메인으로 넘어가기
                viewController.userExisted()
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다. ", isCancelActionIncluded: false)
                }
            }
        }
    }
    
    // 회원가입
    func kakaoSignup(nickname: String, token: String, viewController: NicknameViewController) {
        let url = URLType.userSignup.makeURL
        let parameters: [String: Any] = [
            "nickname" : nickname,
            "socialType": "KAKAO"
        ]
        let headers: HTTPHeaders = ["social-token": token, "Content-Type": "application/json"]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseString { response in
            switch response.result {
            case .success(let response):
                let jwtToken = response
                
                self.keychain.set(jwtToken, forKey: Keys.token)
                self.keychain.set("카카오 로그인", forKey: Keys.loginType)
                self.keychain.set(nickname, forKey: Keys.nickname)
                
                print("token: \(jwtToken)")
                print("login type: kakao")
                
                // 메인으로 넘어가기
                viewController.didRetreiveData()
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다. ", isCancelActionIncluded: false)
                }
            }
        }
    }
    
    
}
