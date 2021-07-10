//
//  OpenSourceTableViewCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/07/10.
//

import UIKit

class OpenSourceTableViewCell: UITableViewCell {
    
    static let identifier = "OpenSourceTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = .white
        self.backgroundColor = .mainPurple
    }

    func configure(text: String) {
        nameLabel.text = text
    }
    
}
