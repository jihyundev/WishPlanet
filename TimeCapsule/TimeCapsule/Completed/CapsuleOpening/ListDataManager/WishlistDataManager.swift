//
//  WishlistDataManager.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/13.
//

import Foundation
import Alamofire

class WishlistDataManager {
    
    let ud = UserDefaults.standard
    
    func getMarbles(viewController: WishlistViewController) {
        //let url = "https://www.vivi-pr.shop/v1/marbles"
        let url = Constant.BASE_URL + "marbles"
        let token = ud.string(forKey: "loginJWTToken")!
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: WishList.self) {
            response in
            switch response.result {
            case .success(let response):
                let marbleList = response.marbleList
                viewController.marbleList = marbleList
                viewController.marbleColorCount = response.marbleColorCount
                viewController.didSuccessMarbleList()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getFinishedMarbles(viewController: FinishedListViewController) {
        //let url = "https://www.vivi-pr.shop/v1/marbles/checked"
        let url = Constant.BASE_URL + "marbles/checked"
        let token = ud.string(forKey: "loginJWTToken")!
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        AF.request(url, method: .get, headers: headers).validate().responseDecodable(of: [MarbleList].self) {
            response in
            switch response.result {
            case .success(let response):
                debugPrint(response)
                viewController.marbleList = response
                viewController.didRetrieveData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
