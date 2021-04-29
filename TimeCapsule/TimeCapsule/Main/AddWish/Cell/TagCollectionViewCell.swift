//
//  TagCollectionViewCell.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    static let identifier = "TagCollectionViewCell"
    
    @IBOutlet weak var colorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.layer.cornerRadius = 9
        colorView.borderColor = .black
        colorView.borderWidth = 3
    }

}
