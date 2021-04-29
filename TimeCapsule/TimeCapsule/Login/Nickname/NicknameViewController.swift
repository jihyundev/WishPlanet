//
//  NicknameViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import UIKit

class NicknameViewController: UIViewController {
    
    let dataManager = UserDataManager()
    var accessToken: String?

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var textCountLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextView.delegate = self
        setupUI()
        prepareKeyboard()
    }
    
    func prepareKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        print(#function)
        guard let userInfo = noti.userInfo else { return }
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
        dataManager.join(nickname: nameTextView.text, token: accessToken!, viewController: self)
        /*
        guard let pvc = self.presentingViewController else { return }
        let nextVC = MainViewController()
        nextVC.modalPresentationStyle = .overCurrentContext
        self.dismiss(animated: true) {
            pvc.present(nextVC, animated: true, completion: nil)
        }*/
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        nameTextView.text = ""
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 30
        containerView.borderWidth = 5
        containerView.borderColor = .black
        
        completionButton.layer.cornerRadius = 8
        completionButton.backgroundColor = UIColor.mainBlack
        completionButton.setTitle("완료", for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.setTitleColor(.white, for: .selected)
        nameTextView.layer.cornerRadius = 9
        nameTextView.backgroundColor = UIColor.mainGrey
    }
    
    func didRetreiveData() {
        guard let pvc = self.presentingViewController else { return }
        let nextVC = MainViewController()
        nextVC.modalPresentationStyle = .overCurrentContext
        self.dismiss(animated: true) {
            pvc.present(nextVC, animated: true, completion: nil)
        }
    }
    


}

extension NicknameViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textCountLabel.text = "(\(min(updatedText.count,10))/10)"
        return updatedText.count <= 10
    }
}
