//
//  Marbles.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/13.
//

import Foundation

struct Marbles: Codable {
    let marbleList: [MarbleList]
    let marbleColorCount: [MarbleColorCount]

    struct MarbleColorCount: Codable {
        let marbleColor: Int
        let marbleCount: Int
    }

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

}


