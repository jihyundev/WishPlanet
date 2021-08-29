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
import AuthenticationServices

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
                    self.verifyUser(loginType: .kakao, accessToken: accessToken!, viewController: viewController)
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
                                self.verifyUser(loginType: .kakao, accessToken: accessToken!, viewController: viewController)
                            }
                        }
                    }
                }
            }
        }
    }
    // 가입 회원 여부 검사
    func verifyUser(loginType: LoginType, accessToken: String, viewController: LoginViewController) {
        print("verifyUser() called")
        let url = URLType.userExists.makeURL
        let parameters: [String: String] = ["socialType": loginType.rawValue]
        let headers: HTTPHeaders = [RequestHeader.socialToken: accessToken]
        AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .queryString), headers: headers, requestModifier: { $0.timeoutInterval = 10 })
            .validate()
            .responseString { response in
            switch response.result {
            case .success(let response):
                if response == "true" {
                    // 이미 가입된 회원
                    print("이미 가입된 회원입니다. ")
                    self.login(loginType: loginType, accessToken: accessToken, viewController: viewController)
                    
                } else {
                    // 회원가입 진행 전 닉네임 설정
                    viewController.goToNickname(loginType: loginType, token: accessToken)
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    viewController.dismissIndicator()
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다. ", isCancelActionIncluded: false)
                }
            }
        }
    }
    
    // 로그인 (JWT 토큰 발급)
    func login(loginType: LoginType, accessToken: String, viewController: LoginViewController) {
        print("login() called")
        let url = URLType.userLogin.makeURL
        let parameters: [String: Any] = ["socialType": loginType.rawValue]
        let headers: HTTPHeaders = [RequestHeader.socialToken: accessToken, RequestHeader.contentType: "application/json"]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 10 })
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
            switch response.result {
            case .success(let response):
                print(response)
                let jwtToken = response.jwtToken
                let rocketStatus = response.rocketStatus
                self.keychain.set(jwtToken, forKey: Keys.token)
                let rocketStatusString = String(rocketStatus)
                self.keychain.set(rocketStatusString, forKey: Keys.rocketStatus)
                self.keychain.set(loginType.rawValue, forKey: Keys.loginType)
                
                // 메인으로 넘어가기
                viewController.userExisted(rocketStatus: rocketStatus)
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    viewController.dismissIndicator()
                    viewController.presentAlert(title: "서버와의 연결이 원활하지 않습니다. ", isCancelActionIncluded: false)
                }
            }
        }
    }
    
    // 회원가입
    func signUp(loginType: LoginType, nickname: String, token: String, viewController: NicknameViewController) {
        print("signUp() called")
        let url = URLType.userSignup.makeURL
        let parameters: [String: Any] = [
            "nickname" : nickname,
            "socialType": loginType.rawValue
        ]
        let headers: HTTPHeaders = [RequestHeader.socialToken: token, RequestHeader.contentType: "application/json"]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 10 })
            .validate()
            .responseString { response in
            switch response.result {
            case .success(let response):
                let jwtToken = response
                
                self.keychain.set(jwtToken, forKey: Keys.token)
                self.keychain.set(loginType.rawValue, forKey: Keys.loginType)
                
                self.keychain.set(nickname, forKey: Keys.nickname)
                self.keychain.set("1", forKey: Keys.rocketStatus)
                
                print("token: \(jwtToken)")
                
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
