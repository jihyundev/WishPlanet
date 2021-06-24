//
//  CheckedListCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/24.
//

import UIKit

class CheckedListCell: UITableViewCell {

    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var stoneImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wishLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .mainPurple
        mainBackgroundView.layer.cornerRadius = 16
        mainBackgroundView.layer.borderColor = UIColor.black.cgColor
        mainBackgroundView.backgroundColor = UIColor(hex: 0xC1B9DB)
        mainBackgroundView.layer.borderWidth = 3
        stoneImageView.alpha = 0.3
        dateLabel.textColor = UIColor(hex: 0x888888)
        dateLabel.font = .SpoqaHanSansNeo(.regular, size: 11)
        wishLabel.textColor = UIColor(hex: 0x888888)
        wishLabel.font = .SpoqaHanSansNeo(.bold, size: 16)
        
        let attrubuteString = NSMutableAttributedString(string: wishLabel.text ?? "")
        attrubuteString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attrubuteString.length))
        wishLabel.attributedText = attrubuteString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
