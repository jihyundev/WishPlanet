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

    /** 초기 라우트 체크*/
    func checkRoute() -> UIViewController {
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
        return UIViewController()
    }
}

/*
if let loginType: LoginType.RawValue = keychain.get(Keys.loginType) {
    print("loginType: \(loginType)")
    switch loginType {
    case LoginType.apple.rawValue:
        print("애플로그인 됨")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: Keys.userIdentifier) { credentialState, error in
            switch credentialState {
            case .authorized:
                print("apple credential authorized.")
            case .revoked, .notFound:
                print("apple credential revoked / not found.")
            default:
                break
            }
        }
    case LoginType.kakao.rawValue:
        print("카카오로그인됨")
    default:
        print("키체인 로그인 정보 없음")
    }
}*/
