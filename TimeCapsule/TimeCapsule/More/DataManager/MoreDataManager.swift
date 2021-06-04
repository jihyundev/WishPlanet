//
//  MoreDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import Foundation
import Alamofire
import KeychainSwift

class MoreDataManager {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    // 더보기 정보 GET
    func getMoreInfo(viewController: MyPageViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let url = URLType.userMore.makeURL
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: GetMoreInfoResponse.self) { response in
            switch response.result {
            case .success(let response):
                let nickname = response.nickName
                let loginType = response.socialType
                self.keychain.set(nickname, forKey: Keys.nickname)
                self.keychain.set(loginType, forKey: Keys.loginType)
                viewController.didRetrieveData(data: response)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    // 우주선 관리 - 우주선 리스트 GET
    func getRocket(viewController: MyPageViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let url = URLType.rocket.makeURL + "?scope=TOTAL&stoneColorCount=false"
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseDecodable(of: [GetRocketsResponse].self) { (response) in
            print("getRocket() called")
            
            switch response.result {
            case .success(let response):
                print(response)
                
                var currentRocket: MyRocket = MyRocket(name: "", period: "", color: 0)
                var launchedRockets: [MyRocket] = []
                
                for rocket in response {
                    let name = rocket.rocketName
                    let color = rocket.rocketColor
                    let date = rocket.launchDate
                    if rocket.launched == true {
                        launchedRockets.append(MyRocket(name: name, period: date, color: color))
                    } else {
                        currentRocket = MyRocket(name: name, period: date, color: color)
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
