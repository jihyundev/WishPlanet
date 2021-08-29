//
//  GetMoreInfoResponse.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import Foundation

struct GetMoreInfoResponse: Codable {
    var nickName, socialType, version: String
    var rocketCount: Int
}
