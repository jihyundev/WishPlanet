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
    
    // 소원석 리스트 GET
    func getStones(rocketID: Int, viewController: CompletedListViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = [RequestHeader.jwtToken: token]
        let url = URLType.stone(rocketID).makeURL
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 10 }).validate().responseDecodable(of: GetStonesResponse.self) { response in
            switch response.result {
            case .success(let response):
                var finishedStones = 0
                for stone in response.stoneList {
                    if stone.wishChecked {
                        finishedStones += 1
                    }
                }
                viewController.didRetrieveData(stoneCount: response.totalStoneCount, finishedStoneCount: finishedStones, stoneList: response.stoneList)
            case .failure(let error):
                print(error)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
            
        }
    }
    
    // 소원석 체크 PATCH
    func patchStoneCheck(checked: Bool, rocketID: Int, stoneID: Int, viewController: CompletedListViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = [RequestHeader.jwtToken: token]
        let url = URLType.stoneCheck(rocketID, stoneID).makeURL
        AF.request(url, method: .patch, headers: headers, requestModifier: { $0.timeoutInterval = 10 })
            .validate().responseString { response in
                switch response.result {
                case .success:
                    print("success")
                    switch checked {
                    case true:
                        viewController.successToCheckStone(message: "소원석 체크가 해제되었습니다. ")
                    case false:
                        viewController.successToCheckStone(message: "소원석 체크가 완료되었습니다. ")
                    }
                case .failure(let error):
                    print(error)
                    viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
                }
            }
    }
}
