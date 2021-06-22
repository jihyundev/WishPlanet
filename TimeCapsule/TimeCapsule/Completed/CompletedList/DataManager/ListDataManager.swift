//
//  ListDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/22.
//

import Foundation
import KeychainSwift
import Alamofire

class ListDataManager {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    func getStones(rocketID: Int, viewController: CompletedListViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let url = URLType.stone(rocketID).makeURL
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 10 }).validate().responseDecodable(of: GetStonesResponse.self) { response in
            switch response.result {
            case .success(let response):
                viewController.didRetrieveData(stoneCount: response.totalStoneCount, stoneList: response.stoneList)
            case .failure(let error):
                print(error)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
            
        }
    }
}
