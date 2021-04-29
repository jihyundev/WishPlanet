//
//  MenuCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import UIKit
import PagingKit

class MenuCell: PagingMenuViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override public var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel.textColor = .white
                titleLabel.font = .SpoqaHanSansNeo(.bold, size: 16)
            } else {
                titleLabel.textColor = UIColor.white.withAlphaComponent(0.3)
                titleLabel.font = .SpoqaHanSansNeo(.bold, size: 16)
            }
        }
    }
}
