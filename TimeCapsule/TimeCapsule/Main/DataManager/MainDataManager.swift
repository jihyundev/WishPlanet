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
    func getRocket() {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let url = URLType.rocket.makeURL + "?scope=AWAITING&stoneColorCount=true"
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseDecodable(of: [GetRocketsResponse].self) { (response) in
            print("getRocket() called")
            /*
            switch response.result {
            case .success(let response):
                print(response)
                let rocket = response[0]
                if rocket.rocketName == "" {
                    self.nameLabel.text = "로켓 이름"
                } else {
                    self.nameLabel.text = rocket.rocketName
                }
                self.marbles = []
                for i in 0..<rocket.stoneColorCount.count {
                    for _ in 0..<rocket.stoneColorCount[i].stoneCount {
                        self.marbles.append(rocket.stoneColorCount[i].stoneColor)
                    }
                }
                self.currentItems = self.marbles.count
                self.makeGameScene()
                self.countLabel.text = ("\(self.marbles.count) / 21")
                print(self.currentItems)
            case .failure(let error):
                print(error.localizedDescription)
                self.presentAlert(title: "서버와의 연결이 원활하지 않습니다. ")
            }
            */
        }
    }
}
