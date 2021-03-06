//
//  AddWishViewController.swift
//  TimeCapsule
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishTextView.delegate = self
        setupUI()
        setupButton()
        prepareKeyboard()
        self.dismissKeyboardWhenTappedAround()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
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
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completionButtonTapped(_ sender: Any) {
        guard let content = wishTextView.text else { return }
        self.view.isUserInteractionEnabled = false
        dataManager.postStone(rocketID: self.rocketID, content: content, stoneColor: self.stoneColor, viewController: self)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- UI ??????
    private func setupUI() {
        wishTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        wishTextView.text = "????????? ??????????????????"
        wishTextView.textColor = .enabledGrey
        wishTextView.returnKeyType = .done
        
        stoneCountLabel.text = "\(count + 1) / 21"
        containerView.layer.cornerRadius = 24
        containerView.borderWidth = 5
        containerView.borderColor = .black
        
        completionButton.layer.cornerRadius = 12
        completionButton.setTitle("??????", for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.setTitleColor(.white, for: .selected)
        
        wishTextView.layer.cornerRadius = 12
        wishTextView.backgroundColor = UIColor.mainGrey
        
        isActivated = false
    }
    
    // MARK:- ?????? ??????, ?????? ?????? ??????
    private func setupButton() {
        redButton.tag = 1
        yellowButton.tag = 2
        greenButton.tag = 3
        blueButton.tag = 4
        purpleButton.tag = 5
        
        redButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        yellowButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        greenButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        blueButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        purpleButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    private func setDefaultImage() {
        redButton.setImage(UIImage(named: "stone_0"), for: .normal)
        yellowButton.setImage(UIImage(named: "stone_1"), for: .normal)
        greenButton.setImage(UIImage(named: "stone_2"), for: .normal)
        blueButton.setImage(UIImage(named: "stone_3"), for: .normal)
        purpleButton.setImage(UIImage(named: "stone_4"), for: .normal)
    }
    
    @objc private func buttonClicked(sender:UIButton) {
        setDefaultImage()
        switch sender.tag {
        case 1:
            redButton.setImage(UIImage(named: "icon_check_0"), for: .normal)
            stoneColor = 0
            break
        case 2:
            yellowButton.setImage(UIImage(named: "icon_check_1"), for: .normal)
            stoneColor = 1
            break
        case 3:
            greenButton.setImage(UIImage(named: "icon_check_2"), for: .normal)
            stoneColor = 2
            break
        case 4:
            blueButton.setImage(UIImage(named: "icon_check_3"), for: .normal)
            stoneColor = 3
            break
        case 5:
            purpleButton.setImage(UIImage(named: "icon_check_4"), for: .normal)
            stoneColor = 4
            break
        default:
            print("Failed to select color button")
        }
    }
    
    func didSuccessToPost() {
        self.view.isUserInteractionEnabled = true
        self.delegate?.reloadView()
        self.dismiss(animated: true) {
            self.delegate?.showToast()
        }
    }
    
    func failedToPost(message: String) {
        self.view.isUserInteractionEnabled = true
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
        if wishTextView.text == "????????? ??????????????????" {
            wishTextView.text = ""
            wishTextView.textColor = .black
        } else if wishTextView.text == "" {
            wishTextView.text = "????????? ??????????????????"
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

extension AddWishViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != containerView
    }
}
