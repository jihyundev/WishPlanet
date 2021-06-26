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
    let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter
    }()
    
    func getRocket(viewController: MainViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let url = URLType.rocket.makeURL
        let parameters = ["scope": "AWAITING", "stoneColorCount": "true"]
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(destination: .queryString), headers: headers, requestModifier: { $0.timeoutInterval = 10 })
            .validate()
            .responseDecodable(of: [GetRocketsResponse].self) { (response) in
            print("getRocket() called")
            
            switch response.result {
            case .success(let response):
                if response.count > 0 {
                    let rocket = response[0]
                    var stones: [Int] = []
                    if let stoneList = rocket.stoneColorCount {
                        for i in 0..<stoneList.count {
                            for _ in 0..<stoneList[i].stoneCount {
                                stones.append(stoneList[i].stoneColor)
                            }
                        }
                    }
                    let daysLeft: Int = self.calculateDaysLeft(launchDate: rocket.launchDate)
                    viewController.didRetrieveData(rocketID: rocket.rocketID, rocketColor: rocket.rocketColor, rocketName: rocket.rocketName, launchDate: rocket.launchDate, stones: stones, rocketCount: rocket.totalRocketCount, daysLeft: daysLeft)
                } else {
                    viewController.failedToRequest(message: "로켓이 존재하지 않습니다. ")
                }
            case .failure(let error):
                print(error.localizedDescription)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
        }
    }
    
    func patchRocketLaunch(rocketID: Int, viewController: EndPopUpViewController) {
        guard let token = keychain.get(Keys.token) else { return }
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let url = URLType.rocketLaunch(rocketID).makeURL
        print("rocketID: \(rocketID)")
        AF.request(url, method: .patch, headers: headers, requestModifier: { $0.timeoutInterval = 10 })
            .validate()
            .responseJSON { response in
            switch response.result {
            case .success(let result):
                print("patchRocketLaunch() - result: ", result)
                viewController.successToPatch()
                self.keychain.set("3", forKey: Keys.rocketStatus) // 로켓 생성 후 발사 완료
            case .failure(let error):
                if let data = response.data {
                    print("Failure Data: \(data)")
                    let jsonString = String(data: data, encoding: .utf8)
                    print("Failure String: \(jsonString ?? "우주선을 발사할 수 없어요. ")")
                }
                print(error.localizedDescription)
                viewController.failedToRequest(message: "서버와의 연결이 원활하지 않습니다. ")
            }
        }
    }
    
    // 현재날로부터 목표일까지 남은 날짜 계산
    func calculateDaysLeft(launchDate: String) -> Int {
        let today = Date()
        let launch = dateformatter.date(from: launchDate)
        var daysLeft: Double?
        if let dateLaunch = launch {
            daysLeft = today.distance(to: dateLaunch) / 86400
            
            return Int(daysLeft?.rounded(.up) ?? 0) // 소수점 올림 처리
            //print("daysLeft: \(daysLeft ?? 0.0)")
            //print("daysLeftInt: \(daysLeftInt)")
        } else {
            return 0
        }
    }
}
