//
//  CreateRocketDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/15.
//

import Foundation
import KeychainSwift
import Alamofire

class CreateRocketDataManager {
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    func postRocket(launchDate: String, rocketColor: Int, rocketName: String) {
        print(#function)
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let url = URLType.rocket.makeURL
        let parameters: [String: Any] = [
            "launchDate" : launchDate,
            "rocketColor": rocketColor,
            "rocketName": rocketName
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseString { response in
            switch response.result {
            case .success(let response):
                self.keychain.set(true, forKey: Keys.rocketExists)
                debugPrint(response)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
