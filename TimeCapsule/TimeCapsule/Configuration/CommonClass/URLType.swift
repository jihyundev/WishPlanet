//
//  URLType.swift
//  TimeCapsule
//
//

import Foundation

enum URLType {
    // user-controller
    case userExists // 회원가입 여부 확인
    case userLogin // 로그인
    case userNickname // 닉네임 수정
    case userSignup // 회원가입
    case userMore // 더보기 메인화면 정보
    case userRockets //내 우주선 관리
    case userDelete // 회원탈퇴
    case userDeleteReasons // 탈퇴사유 등록
    
    // rocket-controller
    case rocket // 우주선 리스트(GET), 만들기(POST)
    case rocketEdit(Int) // 우주선 정보 수정
    case rocketLaunch(Int) // 우주선 발사
    case stone(Int) // 소원석 목록(GET), 추가(POST)
    case stoneCheck(Int, Int) // 소원석 체크
    
    case privacyPolicy // 개인정보 처리방침
    
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
            return "\(baseURL)/v1/users/nicknames"
        case .userSignup:
            return "\(baseURL)/v1/users/signUp"
        case .userMore:
            return "\(baseURL)/v1/users/more-informations"
        case .userRockets:
            return "\(baseURL)/v1/users/rockets"
        case .userDelete:
            return "\(baseURL)/v1/users"
        case .userDeleteReasons:
            return "\(baseURL)/v1/users/reasons"
            
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
        case .privacyPolicy:
            return "https://www.notion.so/fddfa4557d6d441096defe68e5589da1"
        }
    }
}
