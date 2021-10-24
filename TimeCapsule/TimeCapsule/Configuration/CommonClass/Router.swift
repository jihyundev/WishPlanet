//
//  Router.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/10/10.
//

import Foundation
import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import KeychainSwift

class Router {
    static let shared = Router()
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)

    /// 초기 라우트 체크
    func checkRoute() -> UIViewController {
        checkSocialLoginStatus()
        let viewController = self.makeFinalEntrypoint()
        return viewController
    }
    
    /// 소셜로그인 토큰 유효성 검사 
    private func checkSocialLoginStatus() -> Void {
        if let loginType: LoginType.RawValue = keychain.get(Keys.loginType) {
            print("loginType: \(loginType)")
            switch loginType {
            case LoginType.apple.rawValue:
                print("애플로그인 id 검사중")
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                appleIDProvider.getCredentialState(forUserID: Keys.userIdentifier) { credentialState, error in
                    switch credentialState {
                    case .authorized:
                        print("apple credential authorized.")
                        // 토큰정보 확인 후 진입점 이동
                    case .revoked, .notFound:
                        print("apple credential revoked / not found.")
                        // LoginVC 로 이동
                    default:
                        break
                        // LoginVC 로 이동
                    }
                }
            case LoginType.kakao.rawValue:
                print("카카오로그인 토큰 검사중...")
                if (AuthApi.hasToken()) {
                    UserApi.shared.accessTokenInfo { (_, error) in
                        if let error = error {
                            // 로그인 필요
                            print(error)
                            print("needa login")
                            // LoginVC 로 이동
                        }
                        else {
                            print("kakao SDK token is valid!")
                            // 토큰정보 확인 후 진입점 이동
                        }
                    }
                }
                else {
                    print("needa login")
                    // LoginVC 로 이동
                }
            default:
                print("we dont have login info in our keychain :(")
                // LoginVC 로 이동
            }
        } else {
            print("we dont have login info in our keychain :(")
            // LoginVC 로 이동
        }
    }
    
    /// 최종 진입점 체크
    func makeFinalEntrypoint() -> UIViewController {
        if let token = self.keychain.get(Keys.token) {
            print("token: \(token)")
            
            if let rocketStatus = self.keychain.get(Keys.rocketStatus) {
                switch rocketStatus {
                case "1":
                    print("로켓이 하나도 없는 상태 (신규회원)")
                    return IntroViewController(flag: 0) // 인트로 소개화면
                case "2":
                    print("로켓 존재, 발사되지 않은 상태")
                    return MainViewController()
                case "3":
                    print("로켓 존재, 발사된 상태")
                    return IntroViewController(flag: 1) // 인트로 소개화면
                default:
                    return IntroViewController(flag: 0) // 인트로 소개화면
                }
            } else {
                return LoginViewController()
            }
        } else {
            // 로그인 처리가 필요한 경우
            return LoginViewController()
        }
    }
}
