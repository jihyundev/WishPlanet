//
//  LoginResponse.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/30.
//

import Foundation

struct LoginResponse: Codable {
    let jwtToken: String
    let rocketStatus: Int
}
