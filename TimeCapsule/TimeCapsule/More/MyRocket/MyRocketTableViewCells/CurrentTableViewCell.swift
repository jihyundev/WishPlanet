//
//  CurrentTableViewCell.swift
//  TableviewSectionTest
//
//  Created by 정지현 on 2021/06/01.
//

import UIKit

class CurrentTableViewCell: UITableViewCell {
    
    let cellID = "CurrentTableViewCell"

    @IBOutlet weak var rocketImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .mainPurple
        editButton.layer.cornerRadius = editButton.layer.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
