//
//  MyInfoDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import Foundation
import Alamofire
import KeychainSwift

class MyInfoDataManager {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    // 닉네임 수정
    func patchNickname(nickname: String, viewController: NicknameEditViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let url = URLType.userNickname.makeURL
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token, "Content-Type": "application/json"]
        let parameters: [String: Any] = [
            "nickName" : nickname
        ]
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseString { response in
            switch response.result {
            case .success( _):
                print(response)
                self.keychain.set(nickname, forKey: Keys.nickname)
                viewController.didRetreiveData()
            case .failure(let error):
                print(response)
                print(error.localizedDescription)
            }
        }
    }
    
    // 회원탈퇴
    func deleteUser(reason: String, viewController: LeaveConfirmViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let url = URLType.userDelete.makeURL
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseString { response in
            switch response.result {
            case .success(let result):
                if result == "true" {
                    self.postReasons(reason: reason, viewController: viewController)
                } else {
                    viewController.failedToDelete()
                }
            case .failure(let error):
                print(error.localizedDescription)
                viewController.failedToDelete()
            }
        }
    }
    
    // 탈퇴 사유 등록
    func postReasons(reason: String, viewController: LeaveConfirmViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let url = URLType.userDeleteReasons.makeURL
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let param: [String: Any] = [
            "reason" : reason
        ]
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseString { response in
            switch response.result {
            case .success(let result):
                print(result)
                if result == "true" {
                    viewController.didRetrieveData()
                } else {
                    viewController.failedToDelete()
                }
            case .failure(let error):
                print(error.localizedDescription)
                viewController.failedToDelete()
            }
        }
    }
}
