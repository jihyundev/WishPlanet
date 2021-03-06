//
//  NicknameViewController.swift
//  TimeCapsule
//
//

import UIKit

class NicknameViewController: UIViewController {
    
    let dataManager = UserDataManager()
    
    private let loginType: LoginType
    private let accessToken: String
    
    var delegate: BacktoLoginDelegate?
    var isActivated: Bool = false {
        didSet {
            if isActivated {
                completionButton.isEnabled = true
                completionButton.backgroundColor = .mainPurple
            } else {
                completionButton.isEnabled = false
                completionButton.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
            }
        }
    }
    
    init(loginType: LoginType, accessToken: String) {
        self.loginType = loginType
        self.accessToken = accessToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        setupUI()
        prepareKeyboard()
    }
    
    func prepareKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.dismissKeyboardWhenTappedAround()
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
        guard let text = nameTextField.text else { return }
        self.view.isUserInteractionEnabled = false
        dataManager.signUp(loginType: loginType, nickname: text, token: accessToken, viewController: self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        nameTextField.text = ""
        isActivated = false
        deleteButton.isHidden = true
        textCountLabel.text = "0/10"
    }
    
    @IBAction func nameTextFieldChanged(_ sender: Any) {
        if nameTextField.text?.isEmpty == false {
            deleteButton.isHidden = false
            textCountLabel.isHidden = false
            isActivated = true
        } else {
            deleteButton.isHidden = true
            textCountLabel.isHidden = true
            isActivated = false
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.fadeinAnimate()
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 24
        containerView.borderWidth = 4
        containerView.borderColor = .black
        
        completionButton.layer.cornerRadius = 12
        completionButton.backgroundColor = UIColor.mainPurple
        completionButton.setTitle("??????", for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.setTitleColor(.white, for: .selected)
        nameTextField.layer.cornerRadius = 12
        nameTextField.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        nameTextField.addLeftPadding()
        textCountLabel.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1.0)
        
        deleteButton.isHidden = true
        isActivated = false
    }
    
    func didRetreiveData() {
        self.view.isUserInteractionEnabled = true
        guard let pvc = self.presentingViewController else { return }
        let nextVC = IntroViewController(flag: 0)
        let vc = UINavigationController(rootViewController: nextVC)
        vc.modalPresentationStyle = .overCurrentContext
        self.dismiss(animated: true) {
            pvc.present(vc, animated: true, completion: nil)
        }
    }
    
    func failedToRequest(message: String) {
        self.view.isUserInteractionEnabled = true
        self.presentAlert(title: message, isCancelActionIncluded: false)
    }
    
}
extension NicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        textCountLabel.text = "\(min(updatedText.count,10))/10"
        return updatedText.count <= 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if nameTextField.text?.isEmpty == true {
            deleteButton.isHidden = true
            textCountLabel.isHidden = true
        } else {
            deleteButton.isHidden = false
            textCountLabel.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        deleteButton.isHidden = true
    }
}
