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
    static let token = "token"
    static let loginType = "loginType"
    static let nickname = "nickname"
}
