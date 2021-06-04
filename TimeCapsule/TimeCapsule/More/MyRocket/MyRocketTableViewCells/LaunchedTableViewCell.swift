//
//  LaunchedTableViewCell.swift
//  TableviewSectionTest
//
//  Created by 정지현 on 2021/06/01.
//

import UIKit

class LaunchedTableViewCell: UITableViewCell {
    
    let cellID = "LaunchedTableViewCell"

    @IBOutlet weak var rocketImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .mainPurple
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
