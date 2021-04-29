//
//  URLType.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import Foundation

enum URLType {
    case capsuleInfo
    case capsuleName
    case capsuleOpen
    
    case marbleList
    case addMarble
    case marbleCheck(Int)
    
    case nickName
    
    var baseURL: String {
        return "http://3.35.129.158"
    }
    
    var makeURL: String {
        switch self {
        case .capsuleInfo:
            return "\(baseURL)/v1/capsules"
        case .capsuleName:
            return "\(baseURL)/v1/capsules/name"
        case .capsuleOpen:
            return "\(baseURL)/v1/capsules/open"
            
        case .marbleList:
            return "\(baseURL)/v1/marbles/no-flag"
        case .addMarble:
            return "\(baseURL)/v1/marbles"
        case .marbleCheck(let id):
            return "\(baseURL)/v1/marbles/\(id)/check"
            
        case .nickName:
            return "\(baseURL)/v1/users/nickname"
    
        }
    }
}
