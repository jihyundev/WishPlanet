//
//  CapsuleInfo.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/13.
//

import Foundation

struct CapsuleInfo: Codable {
    let allowedMarbleCount, capsuleID: Int
    let capsuleName: String
    let marbleColorCount: [MarbleColorCount]
    let usedCount: Int

    enum CodingKeys: String, CodingKey {
        case allowedMarbleCount
        case capsuleID = "capsuleId"
        case capsuleName, marbleColorCount, usedCount
    }
    
    struct MarbleColorCount: Codable {
        let marbleColor: Int
        let marbleCount: Int
    }
}

