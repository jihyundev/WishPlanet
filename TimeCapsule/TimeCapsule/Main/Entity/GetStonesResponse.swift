//
//  GetStonesResponse.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/04/30.
//

import Foundation

// MARK: - GetStonesResponse
struct GetStonesResponse: Codable {
    let stoneColorCount: [StoneColorCount]
    let stoneList: [StoneList]
    let totalStoneCount: Int
}

// MARK: - StoneList
struct StoneList: Codable {
    let content, createdAt: String
    let stoneColor, stoneID: Int
    let wishChecked: Bool

    enum CodingKeys: String, CodingKey {
        case content, createdAt, stoneColor
        case stoneID = "stoneId"
        case wishChecked
    }
}
