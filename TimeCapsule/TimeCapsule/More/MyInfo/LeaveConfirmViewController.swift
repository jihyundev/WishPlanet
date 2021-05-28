//
//  LeaveConfirmViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit
import KeychainSwift

class LeaveConfirmViewController: UIViewController {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let dataManager = MyInfoDataManager()
    var isActivated: Bool = false {
        didSet {
            if isActivated == false {
                leaveButton.isEnabled = false
                leaveButton.setTitleColor(UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3), for: .normal)
            } else {
                leaveButton.isEnabled = true
                leaveButton.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var leaveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        setupUI()
        self.dismissKeyboardWhenTappedAround()
    }
    
    fileprivate func setupUI() {
        self.title = "탈퇴하기"
        view.backgroundColor = .mainPurple
        mainTitleLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 18)
        descLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 14)
        
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        textView.font = UIFont.SpoqaHanSansNeo(.medium, size: 16)
        textView.backgroundColor = #colorLiteral(red: 0.574090004, green: 0.2919068336, blue: 0.9963703752, alpha: 1)
        textView.text = "탈퇴 사유를 입력해주세요."
        textView.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        
        leaveButton.layer.cornerRadius = 12
        leaveButton.backgroundColor = #colorLiteral(red: 0.4958559275, green: 0.1930817962, blue: 0.9492445588, alpha: 1)
        leaveButton.titleLabel?.font = UIFont.SpoqaHanSansNeo(.medium, size: 15)
        isActivated = false
    }
    
    @IBAction func leaveButtonTapped(_ sender: Any) {
        dataManager.deleteUser(reason: textView.text, viewController: self)
    }
    
    func didRetrieveData() {
        keychain.clear()
        let loginVC = LoginViewController()
        self.navigationController?.changeRootViewController(loginVC)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func failedToDelete() {
        self.presentAlert(title: "탈퇴에 실패하였습니다. ", isCancelActionIncluded: false)
    }
    
}
extension LeaveConfirmViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        guard textView.text.count < 100 else { return false }
        return true
    }
    
    // Placeholder 설정
    func textViewSetupView() {
        if textView.text == "탈퇴 사유를 입력해주세요." {
            textView.text = ""
            textView.textColor = .white
        } else if textView.text == "" {
            textView.text = "탈퇴 사유를 입력해주세요."
            textView.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        } else {
            textView.textColor = .white
        }
    }
    
    // 편집이 시작될 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    // 편집이 종료될 때
    func textViewDidEndEditing(_ textView: UITextView) {
        print(#function)
        if textView.text.isEmpty == true {
            textViewSetupView()
            isActivated = false
        } else {
            isActivated = true
        }
    }
    
}
