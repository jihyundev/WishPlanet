//
//  UserModel.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import Foundation

struct Signup: Codable {
    let code, message: String
}


struct Keys {
    static let keyPrefix = "wishplanet_"
    static let token = "token" // String
    static let loginType = "loginType" // String
    static let nickname = "nickname" // String
    
    // Bool, 우주선 존재 여부
    static let rocketExists = "rocketExists"
    
    // Bool, 우주선이 없는 경우 체크
    // 1개 만들고 발사해서 우주선이 없는 유저일 경우 true / 우주선 한 번도 안 만들어본 유저일 경우 값이 없거나 false
    static let rocketLaunched = "rocketLaunched"
}
