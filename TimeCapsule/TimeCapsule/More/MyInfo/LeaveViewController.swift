//
//  LeaveViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

class LeaveViewController: UIViewController {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var proceedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "탈퇴하기"
        setupUI()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .mainPurple
        mainTitleLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 18)
        descLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 14)
        proceedButton.layer.cornerRadius = 12
        proceedButton.backgroundColor = #colorLiteral(red: 0.4958559275, green: 0.1930817962, blue: 0.9492445588, alpha: 1)
        proceedButton.titleLabel?.font = UIFont.SpoqaHanSansNeo(.medium, size: 15)
    }
    
    @IBAction func proceedButtonTapped(_ sender: Any) {
        let vc = LeaveConfirmViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
