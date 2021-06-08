//
//  EndPopUpViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/13.
//

import UIKit

class EndPopUpViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var completionButton: UIButton!
    
    weak var delegate: ReloadDelegate?
    var dateString: String?
    var rocketID: Int?
    let dataManager = MainDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completionButtonTapped(_ sender: Any) {
        guard let id = rocketID else { return }
        dataManager.patchRocketLaunch(rocketID: id, viewController: self)
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 24
        containerView.borderWidth = 4
        containerView.borderColor = .black
        
        ddayLabel.textColor = UIColor.mainPurple
        ddayLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 12)
        
        if let date = self.dateString {
            dateLabel.text = date
            dateLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 14)
        }
        
        completionButton.layer.cornerRadius = 12
        completionButton.backgroundColor = UIColor.mainPurple
        completionButton.setTitle("발사하기", for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.titleLabel?.font = UIFont.SpoqaHanSansNeo(.bold, size: 15)
 
    }
    
    func successToPatch() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            // 로켓발사 퍼포먼스
            self.delegate?.endGame()
        }
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }

}
