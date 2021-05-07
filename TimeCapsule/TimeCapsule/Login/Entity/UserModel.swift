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
    static let rocketExists = "rocketExists" // Bool
}
