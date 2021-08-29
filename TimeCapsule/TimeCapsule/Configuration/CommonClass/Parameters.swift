//
//  Parameters.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/27.
//

import Foundation



struct RequestHeader {
    static let jwtToken = "X-ACCESS-TOKEN"
    static let socialToken = "social-token"
    static let contentType = "Content-Type"
}

enum Scope: String {
    case AWAITING = "AWAITING"
    case LAUNCHED = "LAUNCHED"
    case TOTAL = "TOTAL"
}

enum LoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
}
