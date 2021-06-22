//
//  WishlistCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import UIKit

class WishlistCell: UITableViewCell {
    
    let cellID = "WishlistCell"

    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var stoneImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wishLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .mainPurple
        mainBackgroundView.layer.cornerRadius = 16
        mainBackgroundView.layer.borderColor = UIColor.black.cgColor
        mainBackgroundView.layer.borderWidth = 3
        
        dateLabel.font = .SpoqaHanSansNeo(.medium, size: 11)
        wishLabel.font = .SpoqaHanSansNeo(.bold, size: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
