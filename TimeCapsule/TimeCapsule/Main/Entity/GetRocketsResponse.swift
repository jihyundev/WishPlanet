//
//  GetRocketsResponse.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/04/30.
//

import Foundation

// MARK: - GetRocketsResponse
struct GetRocketsResponse: Codable {
    let rocketID, rocketColor: Int
    let rocketName: String
    let allowedStoneCount, usedCount: Int
    let launched: Bool
    let createdAt, launchDate: String
    let stoneColorCount: [StoneColorCount]?
    let totalRocketCount, launchDateModifiedCount: Int

    enum CodingKeys: String, CodingKey {
        case rocketID = "rocketId"
        case rocketColor, rocketName, allowedStoneCount, usedCount, launched, createdAt, launchDate, stoneColorCount, totalRocketCount, launchDateModifiedCount
    }
}

// MARK: - StoneColorCount
struct StoneColorCount: Codable {
    let stoneColor, stoneCount: Int
}

