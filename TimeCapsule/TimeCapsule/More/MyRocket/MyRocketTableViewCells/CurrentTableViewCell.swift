//
//  CurrentTableViewCell.swift
//  TableviewSectionTest
//
//  Created by 정지현 on 2021/06/01.
//

import UIKit

class CurrentTableViewCell: UITableViewCell {
    
    let cellID = "CurrentTableViewCell"
    var rocketID: Int?
    var date: String?
    weak var delegate: MovetoEditRocketDelegate?

    @IBOutlet weak var rocketImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .mainPurple
        editButton.layer.cornerRadius = editButton.layer.frame.height / 2
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func editButtonTapped() {
        if let dateString = date {
            delegate?.moveToEditVC(title: "진행 중", rocketID: rocketID ?? 0, date: dateString)
        }
        
    }
    
}
