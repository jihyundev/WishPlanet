//
//  AddWishViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import UIKit
import Alamofire

class AddWishViewController: UIViewController{
    
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var wishTextView: UITextView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var centerY: NSLayoutConstraint!
    var delegate: ReloadDelegate?
    var tagID: Int = 0
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishTextView.delegate = self
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
        
        //서버로 데이터 전송
        guard let content = wishTextView.text else { return }
        addMarbles(content: content, index: tagID)
        //dismiss
//        delegate?.reloadView()
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        wishTextView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textCountLabel.text = "\(count+1) / 21"
        containerView.layer.cornerRadius = 30
        containerView.borderWidth = 5
        containerView.borderColor = .black
        
        completionButton.layer.cornerRadius = 8
        completionButton.backgroundColor = UIColor.mainBlack
        completionButton.setTitle("완료", for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.setTitleColor(.white, for: .selected)
        
        wishTextView.layer.cornerRadius = 9
        wishTextView.backgroundColor = UIColor.mainGrey
    }
    
    func addMarbles(content: String, index: Int) {
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": Constant.testToken]
        let params = ["content": content,
                      "marbleColor": "\(index)"]
        
        let url = URLType.addMarble.makeURL
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: headers)
            .response { [weak self] response in
                print(response)
                guard let self = self else { return }
                self.delegate?.reloadView()
                self.dismiss(animated: true, completion: nil)
            }
            
    }
}

extension AddWishViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textCount.text = "(\(min(updatedText.count,21))/21)"
        return updatedText.count <= 21
    }
}
