//
//  RocketNameViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

class RocketNameViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        containerView.layer.cornerRadius = 24
        containerView.layer.borderWidth = 4
        containerView.layer.borderColor = UIColor.black.cgColor
        textField.addLeftPadding()
        clearButton.isHidden = true
        countLabel.isHidden = true
        completeButton.layer.cornerRadius = 12
        completeButton.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1)
        
        descLabel.numberOfLines = 0
        descLabel.setLineHeight(lineHeightMultiple: 1.06)
        descLabel.text = "우주선은 한 기간동안 1대만 가능합니다. \n발사 이후 추가가능합니다."
    }

}
