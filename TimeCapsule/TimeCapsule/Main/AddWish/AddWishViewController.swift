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
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    @IBOutlet weak var wishTextView: UITextView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let dataManager = AddWishDataManager()
    
    weak var delegate: ReloadDelegate?
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
    
    private var rocketID: Int
    private var count: Int
    
    init(rocketID: Int, count: Int) {
        self.rocketID = rocketID
        self.count = count
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    @objc private func adjustInputView(noti: Notification) {
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
        guard let content = wishTextView.text else { return }
        dataManager.postStone(rocketID: self.rocketID, content: content, stoneColor: self.stoneColor, viewController: self)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        wishTextView.contentInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        wishTextView.text = "소원을 입력해주세요"
        wishTextView.textColor = .enabledGrey
        wishTextView.returnKeyType = .done
        
        stoneCountLabel.text = "\(count + 1) / 21"
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
    
    fileprivate func setDefaultImage() {
        redButton.setImage(UIImage(named: "stone_0"), for: .normal)
        yellowButton.setImage(UIImage(named: "stone_1"), for: .normal)
        greenButton.setImage(UIImage(named: "stone_2"), for: .normal)
        blueButton.setImage(UIImage(named: "stone_3"), for: .normal)
        purpleButton.setImage(UIImage(named: "stone_4"), for: .normal)
    }
    
    @IBAction func redButtonTapped(_ sender: Any) {
        setDefaultImage()
        redButton.setImage(UIImage(named: "icon_check_0"), for: .normal)
        stoneColor = 0
    }
    
    @IBAction func yellowButtonTapped(_ sender: Any) {
        setDefaultImage()
        yellowButton.setImage(UIImage(named: "icon_check_1"), for: .normal)
        stoneColor = 1
    }
    
    @IBAction func greenButtonTapped(_ sender: Any) {
        setDefaultImage()
        greenButton.setImage(UIImage(named: "icon_check_2"), for: .normal)
        stoneColor = 2
    }
    
    @IBAction func blueButtonTapped(_ sender: Any) {
        setDefaultImage()
        blueButton.setImage(UIImage(named: "icon_check_3"), for: .normal)
        stoneColor = 3
    }
    @IBAction func purpleButtonTapped(_ sender: Any) {
        setDefaultImage()
        purpleButton.setImage(UIImage(named: "icon_check_4"), for: .normal)
        stoneColor = 4
    }
    
    
    func didSuccessToPost() {
        self.delegate?.reloadView()
        self.dismiss(animated: true) {
            self.delegate?.showToast()
        }
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
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty == true {
            isActivated = false
        } else {
            isActivated = true
        }
    }
}
