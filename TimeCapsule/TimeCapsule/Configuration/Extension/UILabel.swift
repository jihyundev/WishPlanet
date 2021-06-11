//
//  UILabel.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

extension UILabel {
    
    func setLineSpace(spacing: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = spacing
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    func setLineHeight(lineHeightMultiple: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = lineHeightMultiple
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    func makeBold(targetString: String) {
        let fontSize = self.font.pointSize
        let font = UIFont.SpoqaHanSansNeo(.bold, size: fontSize)
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString, options: String.CompareOptions.caseInsensitive)
        let attributeStr = NSMutableAttributedString.init(string: fullText)
        attributeStr.addAttribute(.font, value: font, range: range)
        self.attributedText = attributeStr
    }
    
}
