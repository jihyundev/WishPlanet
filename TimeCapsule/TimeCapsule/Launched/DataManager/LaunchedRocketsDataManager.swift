//
//  LaunchedRocketsDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/08/28.
//

import Foundation
import KeychainSwift
import Alamofire


class LaunchedRocketsDataManager {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    // 완료화면 우주선 리스트 조회
    func getCompletedRockets(viewController: LaunchedRocketsViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let url = URLType.rocket.makeURL
        let parameters = ["scope": Scope.LAUNCHED.rawValue, "stoneColorCount": "true"]
        let headers: HTTPHeaders = [RequestHeader.jwtToken: token]
        AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .queryString), headers: headers, requestModifier: { $0.timeoutInterval = 10 })
            .validate()
            .responseDecodable(of: [GetRocketsResponse].self) { (response) in
            print("getRocket() called")
            switch response.result {
            case .success(let response):
                print(response)
                if response.count > 0 {
                    viewController.didRetrieveData(rockets: response)
                } else {
                    viewController.failedToRequest(message: "로켓이 존재하지 않습니다. ")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
        }
    }
    
}
