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
}
