//
//  AddWishViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import UIKit
import Alamofire
import KeychainSwift

class AddWishViewController: UIViewController{
    
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var stoneCountLabel: UILabel!
    @IBOutlet weak var wishTextView: UITextView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let dataManager = AddWishDataManager()
    
    var delegate: ReloadDelegate?
    var rocketID: Int?
    var count: Int?
    var stoneColor: Int = 0
    
    var isActivated: Bool = false {
        didSet {
            if isActivated == false {
                completionButton.isEnabled = false
                completionButton.backgroundColor = .enabledGrey
            } else {
                completionButton.isEnabled = true
                completionButton.backgroundColor = .mainPurple
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishTextView.delegate = self
        setupUI()
        prepareKeyboard()
        self.dismissKeyboardWhenTappedAround()
    }
    
    func prepareKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustInputView(noti: Notification) {        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification{
            centerY.constant = -keyboardFrame.height / 3
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            centerY.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func completionButtonTapped(_ sender: Any) {
        guard let id = self.rocketID, let content = wishTextView.text else { return }
        dataManager.postStone(rocketID: id, content: content, stoneColor: self.stoneColor, viewController: self)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        wishTextView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        wishTextView.text = "소원을 입력해주세요"
        wishTextView.textColor = .enabledGrey
        wishTextView.returnKeyType = .done
        
        stoneCountLabel.text = "\(count ?? 0 + 1) / 21"
        containerView.layer.cornerRadius = 24
        containerView.borderWidth = 5
        containerView.borderColor = .black
        
        completionButton.layer.cornerRadius = 12
        completionButton.setTitle("완료", for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.setTitleColor(.white, for: .selected)
        
        wishTextView.layer.cornerRadius = 12
        wishTextView.backgroundColor = UIColor.mainGrey
        
        isActivated = false
    }
    
    func didSuccessToPost() {
        self.delegate?.reloadView()
        self.dismiss(animated: true, completion: nil)
    }
    
    func failedToPost(message: String) {
        self.presentAlert(title: message, isCancelActionIncluded: false)
    }
}

extension AddWishViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textCountLabel.text = "(\(min(updatedText.count,21))/21)"
        return updatedText.count <= 21
    }
    
    func textViewSetupView() {
        if wishTextView.text == "소원을 입력해주세요" {
            wishTextView.text = ""
            wishTextView.textColor = .black
        } else if wishTextView.text == "" {
            wishTextView.text = "소원을 입력해주세요"
            wishTextView.textColor = .enabledGrey
        } else {
            wishTextView.textColor = .black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            textViewSetupView()
            isActivated = false
        } else {
            isActivated = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wishTextView.resignFirstResponder()
    }
}
