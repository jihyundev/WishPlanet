//
//  MyInfoTableViewCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import UIKit

class MyInfoTableViewCell: UITableViewCell {
    
    let cellID = "MyInfoTableViewCell"
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .mainPurple
        mainLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 15)
        subLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 14)
    }
    
    func configure(main: String, sub: String?, color: Colors) {
        mainLabel.text = main
        subLabel.text = sub ?? ""
        switch color {
        case .darkPurple:
            [mainLabel, subLabel].forEach{ $0.textColor = UIColor.darkPurple }
        case .white:
            [mainLabel, subLabel].forEach{ $0.textColor = UIColor.white }
        default:
            [mainLabel, subLabel].forEach{ $0.textColor = UIColor.white }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
