//
//  URLType.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import Foundation

enum URLType {
    // user-controller
    case userExists // 회원가입 여부 확인
    case userLogin // 로그인
    case userNickname // 닉네임 수정
    case userSignup // 회원가입
    
    // rocket-controller
    case rocket // 우주선 리스트(GET), 만들기(POST)
    case rocketEdit(Int) // 우주선 정보 수정
    case rocketLaunch(Int) // 우주선 발사
    case stone(Int) // 소원석 목록(GET), 추가(POST)
    case stoneCheck(Int, Int) // 소원석 체크
    
    case capsuleInfo
    case capsuleName
    case capsuleOpen
    
    case marbleList
    case addMarble
    case marbleCheck(Int)
    
    case nickName
    
    var baseURL: String {
        return "http://18.216.19.165"
    }
    
    var makeURL: String {
        switch self {
        case .userExists:
            return "\(baseURL)/v1/users/exists"
        case .userLogin:
            return "\(baseURL)/v1/users/login"
        case .userNickname:
            return "\(baseURL)/v1/users/nickname"
        case .userSignup:
            return "\(baseURL)/v1/users/signup"
            
        case .rocket:
            return "\(baseURL)/v1/rockets"
        case .rocketEdit(let id):
            return "\(baseURL)/v1/rockets/\(id)"
        case .rocketLaunch(let id):
            return "\(baseURL)/v1/rockets/\(id)/launch"
        case .stone(let id):
            return "\(baseURL)/v1/rockets/\(id)/stones"
        case .stoneCheck(let rocketId, let stoneId):
            return "\(baseURL)/v1/rockets/\(rocketId)/stones/\(stoneId)/check"
        
            
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
