//
//  SceneDelegate.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import UIKit
import KakaoSDKAuth
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let ud = UserDefaults.standard
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        if let token = keychain.get(Keys.token) {
            // 키체인에 토큰이 존재할 경우
            // 추후 토큰 유효성검사 API 연동 필요 (자동로그인 반영시)
            
            print("token: \(token)")
            
            // 테스트용
            //self.keychain.set(true, forKey: Keys.rocketExists)
            
            if let _ = keychain.get(Keys.rocketExists) {
                // 토큰 있고 우주선 있을 경우 메인 VC로 이동
                self.window = UIWindow(windowScene: scene)
                let mainVC = MainViewController()
                let vc = UINavigationController(rootViewController: mainVC)
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
                window?.overrideUserInterfaceStyle = .light
            } else {
                // 토큰 있고 우주선 없을 경우 인트로 VC로 이동
                self.window = UIWindow(windowScene: scene)
                let introVC = IntroViewController()
                let vc = UINavigationController(rootViewController: introVC)
                window?.rootViewController = vc
                window?.makeKeyAndVisible()
                window?.overrideUserInterfaceStyle = .light
            }
        } else {
            // 로그인 처리가 필요한 경우
            self.window = UIWindow(windowScene: scene)
            window?.rootViewController = LoginViewController()
            window?.makeKeyAndVisible()
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

