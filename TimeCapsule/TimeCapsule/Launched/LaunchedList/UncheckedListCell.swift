//
//  UncheckedListCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/23.
//

import UIKit

class UncheckedListCell: UITableViewCell {
    
    static let identifier = "UncheckedListCell"

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
    
    func configure(color: Int, date: String, wish: String) {
        stoneImageView.image = UIImage(named: "small_dol_\(color + 1)")
        dateLabel.text = date
        wishLabel.text = wish
    }
    
}
