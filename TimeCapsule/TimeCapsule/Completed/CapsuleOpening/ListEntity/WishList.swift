//
//  WishList.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/13.
//

import Foundation

// MARK: - WishList
struct WishList: Codable {
    let marbleList: [MarbleList]
    let marbleColorCount: [MarbleColorCount]
}

// MARK: - MarbleColorCount
struct MarbleColorCount: Codable {
    let marbleColor, marbleCount: Int
}

// MARK: - MarbleList
struct MarbleList: Codable {
    let marbleID: Int
    let content: String
    let marbleColor: Int
    let wishChecked: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case marbleID = "marbleId"
        case content, marbleColor, wishChecked, createdAt
    }
}
