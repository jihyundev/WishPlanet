//
//  EndPopUpViewController.swift
//  TimeCapsule
//
//

import UIKit

class EndPopUpViewController: UIViewController {
    
    let dataManager = MainDataManager()
    let dday: String
    let dateString: String
    let rocketID: Int
    
    weak var delegate: ReloadDelegate?
    
    init(dday: String, dateString: String, rocketID: Int) {
        self.dday = dday
        self.dateString = dateString
        self.rocketID = rocketID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var completionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completionButtonTapped(_ sender: Any) {
        dataManager.patchRocketLaunch(rocketID: rocketID, viewController: self)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 24
        containerView.borderWidth = 4
        containerView.borderColor = .black
        
        ddayLabel.text = dday
        ddayLabel.textColor = UIColor.mainPurple
        ddayLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 12)
        
        dateLabel.text = dateString
        dateLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 14)
        
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

extension EndPopUpViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != containerView
    }
}
