//
//  LaunchedRocketsCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/08/22.
//

import UIKit

class LaunchedRocketsCell: UICollectionViewCell {
    
    static let identifier = "LaunchedRocketsCell"

    @IBOutlet weak var rocketNameLabel: UILabel!
    @IBOutlet weak var rocketImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rocketNameLabel.text = ""
    }
    
    func configure(name: String, color: Int) {
        rocketNameLabel.text = name
        rocketImageView.image = UIImage(named: "icon rocket_\(color)_mid")
    }

}
