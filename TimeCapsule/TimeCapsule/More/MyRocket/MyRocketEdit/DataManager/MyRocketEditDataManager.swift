//
//  MyRocketEditDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/06.
//

import Foundation
import Alamofire
import KeychainSwift

class MyRocketEditDataManager {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    func getRocketDetails(rocketID: Int, viewController: MyRocketEditViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let url = URLType.rocketEdit(rocketID).makeURL
        let headers: HTTPHeaders = [RequestHeader.jwtToken: token]
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 10 }).validate().responseDecodable(of: GetRocketsResponse.self) { response in
            switch response.result {
            case .success(let res):
                let color = res.rocketColor
                let name = res.rocketName
                let date = res.launchDate
                var canModify = true
                if res.launchDateModifiedCount >= 1 {
                    canModify = false
                } else {
                    canModify = true
                }
                viewController.didRetrieveData(rocketColor: color, name: name, date: date, canPatch: canModify)
            case .failure(let error):
                print(error.localizedDescription)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
        }
    }
    
    func patchRocketDetails(rocketID: Int, name: String, date: String, viewController: MyRocketEditViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let url = URLType.rocketEdit(rocketID).makeURL
        let headers: HTTPHeaders = [RequestHeader.jwtToken: token]
        let parameters: [String: Any] = [
            "launchDate": date,
            "rocketName": name
        ]
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers, requestModifier: { $0.timeoutInterval = 10 }).validate().responseString { response in
            switch response.result {
            case .success(let res):
                print(res)
                viewController.successToPatch()
            case .failure(let error):
                print(error.localizedDescription)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
        }
    }
}
