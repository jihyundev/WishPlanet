//
//  Constant.swift
//  EduTemplate
//
//  Created by Zero Yoon on 2020/10/08.
//

import Foundation

struct Constant {
    //static let BASE_URL = "https://www.vivi-pr.shop/v1/"
    static let BASE_URL = "http://3.35.129.158/v1/"
//    static let testToken = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsImlhdCI6MTYxNTU1MTI1MX0.azhpQs7mOZhUBY46A9XOz_xzD18nfX59wqacFcmuqWM"
    static let testToken =  UserDefaults.standard.string(forKey: "loginJWTToken")!

}
