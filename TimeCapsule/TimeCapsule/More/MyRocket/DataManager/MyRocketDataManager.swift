//
//  MyRocketDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/06.
//

import Foundation
import Alamofire
import KeychainSwift

class MyRocketDataManager {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    // 우주선 관리 - 우주선 리스트 GET
    func getRocket(viewController: MyRocketViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let url = URLType.rocket.makeURL + "?scope=TOTAL&stoneColorCount=false"
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 10 }).validate().responseDecodable(of: [GetRocketsResponse].self) { (response) in
            print("getRocket() called")
            
            switch response.result {
            case .success(let response):
                print(response)
                
                var currentRocket: MyRocket = MyRocket(rocketID: 0, name: "", period: "", color: 0)
                var launchedRockets: [MyRocket] = []
                
                for rocket in response {
                    let id = rocket.rocketID
                    let name = rocket.rocketName
                    let color = rocket.rocketColor
                    let date = rocket.launchDate
                    if rocket.launched == true {
                        launchedRockets.append(MyRocket(rocketID: id, name: name, period: date, color: color))
                    } else {
                        currentRocket = MyRocket(rocketID: id, name: name, period: date, color: color)
                    }
                }
                viewController.didRetrieveRocketData(current: currentRocket, launched: launchedRockets)
                
            case .failure(let error):
                print(error.localizedDescription)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
        }
    }
}
