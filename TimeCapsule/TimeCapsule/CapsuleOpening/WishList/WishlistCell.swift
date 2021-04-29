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
        self.backgroundColor = #colorLiteral(red: 0.4529297948, green: 0.2904702425, blue: 1, alpha: 1)
        mainBackgroundView.layer.cornerRadius = 8
        mainBackgroundView.layer.borderColor = UIColor.black.cgColor
        mainBackgroundView.layer.borderWidth = 3
        
        dateLabel.font = .SpoqaHanSansNeo(.regular, size: 12)
        wishLabel.font = .SpoqaHanSansNeo(.bold, size: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
