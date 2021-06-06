//
//  MyRocket.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/02.
//

import Foundation

class MyRocket {
    var rocketID: Int
    var name: String
    var period: String
    var color: Int
    
    init(rocketID: Int, name: String, period: String, color: Int) {
        self.rocketID = rocketID
        self.name = name
        self.period = period
        self.color = color
    }
}
