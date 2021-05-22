//
//  MainDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/17.
//

import Foundation
import KeychainSwift
import Alamofire

class MainDataManager {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    func getRocket(viewController: MainViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let url = URLType.rocket.makeURL + "?scope=AWAITING&stoneColorCount=true"
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseDecodable(of: [GetRocketsResponse].self) { (response) in
            print("getRocket() called")
            
            switch response.result {
            case .success(let response):
                print(response)
                let rocket = response[0]
                var stones: [Int] = []
                for i in 0..<rocket.stoneColorCount.count {
                    for _ in 0..<rocket.stoneColorCount[i].stoneCount {
                        stones.append(rocket.stoneColorCount[i].stoneColor)
                    }
                }
                viewController.didRetrieveData(rocketID: rocket.rocketID, rocketColor: rocket.rocketColor, rocketName: rocket.rocketName, launchDate: rocket.launchDate, stones: stones)
            case .failure(let error):
                print(error.localizedDescription)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
        }
    }
}
