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
}
