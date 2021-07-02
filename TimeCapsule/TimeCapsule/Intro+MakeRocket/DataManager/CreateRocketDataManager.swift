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
    func postRocket(launchDate: String, rocketColor: Int, rocketName: String, viewController: RocketDateViewController) {
        print(#function)
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = [RequestHeader.jwtToken: token, RequestHeader.contentType: "application/json"]
        let url = URLType.rocket.makeURL
        let parameters: [String: Any] = [
            "launchDate" : launchDate,
            "rocketColor": rocketColor,
            "rocketName": rocketName
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseString { response in
            switch response.result {
            case .success(let response):
                debugPrint(response)
                self.keychain.set("2", forKey: Keys.rocketStatus) // 로켓 생성 완료
                viewController.didSuccessToPost()
            case .failure(let error):
                debugPrint(error.localizedDescription)
                viewController.failedToPost()
            }
        }
    }
}
