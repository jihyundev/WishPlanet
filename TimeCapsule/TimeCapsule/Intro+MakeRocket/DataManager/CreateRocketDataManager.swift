//
//  CreateRocketDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/15.
//

import Foundation
import KeychainSwift
import Alamofire
import SwiftyJSON

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
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 10 }).validate().responseData { response in
            guard let data = response.data else { return }
            let json = try? JSON(data: data)
            switch response.result {
            case .success:
                self.keychain.set("2", forKey: Keys.rocketStatus) // 로켓 생성 완료
                viewController.didSuccessToPost()
            case .failure(let error):
                print(error)
                let message = json?["message"] ?? "서버와의 연결이 원활하지 않습니다. "
                viewController.failedToPost(message: message.rawValue as! String)
            }
        }
        
    }
}
