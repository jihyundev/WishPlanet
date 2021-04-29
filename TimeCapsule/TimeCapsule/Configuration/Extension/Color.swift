//
//  Color.swift
//  EduTemplate
//
//  Created by Zero Yoon on 2020/10/08.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    class var mainOrange: UIColor { UIColor(hex: 0xF5663F) }
    class var mainGrey: UIColor { UIColor(hex: 0xEFEFEF)}
    class var mainBlack: UIColor { UIColor(hex: 0x2C2C2C)}
}

let mainColorSet: [UIColor] = [UIColor(hex: 0xFF5858),
                                  UIColor(hex: 0xFFF96C),
                                  UIColor(hex: 0x9DF483),
                                  UIColor(hex: 0x60D4FF),
                                  UIColor(hex: 0xC179FF)
]
