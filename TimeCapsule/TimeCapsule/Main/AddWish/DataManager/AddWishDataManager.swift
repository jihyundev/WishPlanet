//
//  AddWishDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/21.
//

import Foundation
import KeychainSwift
import Alamofire
import SwiftyJSON

class AddWishDataManager {
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    // 소원석 추가
    func postStone(rocketID: Int, content: String, stoneColor: Int, viewController: AddWishViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token, "Content-Type": "application/json"]
        let url = URLType.stone(rocketID).makeURL
        let parameters: [String: Any] = [
            "content" : content,
            "stoneColor": stoneColor
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 10 }).validate().responseData { response in
            if let data = response.data {
                let json = try? JSON(data: data)
                switch response.result {
                case .success(_):
                    viewController.didSuccessToPost()
                case .failure(let error):
                    print(error)
                    let message = json?["message"] ?? "서버와의 연결이 원활하지 않습니다. "
                    viewController.failedToPost(message: message.rawValue as? String ?? "서버와의 연결이 원활하지 않습니다. ")
                }
            }
        }
        
    }
}
