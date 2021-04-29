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

class UserDataManager {
    
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
        let url = Constant.BASE_URL + "users/exists"
        let headers: HTTPHeaders = ["social-token": accessToken]
        AF.request(url, method: .get, headers: headers).validate().responseString { response in
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
            }
        }
    }
    
    // 로그인 (JWT 토큰 발급)
    func login(accessToken: String, viewController: LoginViewController) {
        print("login() called")
        //let url = "https://www.vivi-pr.shop/v1/users/login"
        let url = Constant.BASE_URL + "users/login"
        let headers: HTTPHeaders = ["social-token": accessToken]
        AF.request(url, method: .post, headers: headers).validate().responseString { response in
            switch response.result {
            case .success(let response):
                let jwtToken = response
                print("token: \(jwtToken)")
                let ud = UserDefaults.standard
                ud.setValue(jwtToken, forKey: "loginJWTToken")
                // 메인으로 넘어가기
                viewController.userExisted()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 닉네임 수정
    func setNickname(nickname: String, viewController: NicknameViewController) {
        let ud = UserDefaults.standard
        let token = ud.string(forKey: "loginJWTToken")!
        //let url = "https://www.vivi-pr.shop/v1/users/nickname"
        let url = Constant.BASE_URL + "users/nickname"
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token, "nicknameDto": nickname]
        AF.request(url, method: .patch, headers: headers).validate().responseString { response in
            switch response.result {
            case .success( _):
                print("닉네임 수정 성공")
                viewController.didRetreiveData()
                //self.join(nickname: nickname, viewController: viewController)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 회원가입
    func join(nickname: String, token: String, viewController: NicknameViewController) {
        //let url = "https://www.vivi-pr.shop/v1/users/signUp"
        let url = Constant.BASE_URL + "users/signUp"
        let parameters: [String: Any] = [
            "nickname" : nickname
        ]
        let headers: HTTPHeaders = ["social-token": token]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseString { response in
            switch response.result {
            case .success(let response):
                let jwtToken = response
                let ud = UserDefaults.standard
                ud.setValue(jwtToken, forKey: "loginJWTToken")
                // 메인으로 넘어가기
                viewController.didRetreiveData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
