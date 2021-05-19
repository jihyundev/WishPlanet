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
    class var mainPurple: UIColor { UIColor(red: 0.48, green: 0.256, blue: 0.958, alpha: 1.0)}
    class var dividePurple: UIColor { UIColor(red: 0.44, green: 0.21, blue: 0.94, alpha: 1.0)}
    class var graphic: UIColor { UIColor(red: 0.706, green: 0.796, blue: 0.949, alpha: 1) }
    
    class var mainGrey: UIColor { UIColor(hex: 0xEFEFEF)}
    class var mainBlack: UIColor { UIColor(hex: 0x2C2C2C)}
    class var enabledGrey: UIColor {UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1)}
}

let mainColorSet: [UIColor] = [UIColor(hex: 0xFF5858),
                                  UIColor(hex: 0xFFF96C),
                                  UIColor(hex: 0x9DF483),
                                  UIColor(hex: 0x60D4FF),
                                  UIColor(hex: 0xC179FF)
]
