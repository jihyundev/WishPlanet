//
//  RocketNameViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

class RocketNameViewController: UIViewController {
    
    var delegate: IntroFadeAnimationDelegate?
    var currentRocket = 0
    var isActivate: Bool = false {
        didSet {
            if isActivate == true {
                completeButton.isEnabled = true
                completeButton.backgroundColor = .mainPurple
            } else {
                completeButton.isEnabled = false
                completeButton.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1)
            }
        }
    }

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prepareKeyboard()
        
        self.dismissKeyboardWhenTappedAround()
        self.isActivate = false
        textField.delegate = self
    }
    
    fileprivate func setupUI() {
        containerView.layer.cornerRadius = 24
        containerView.layer.borderWidth = 4
        containerView.layer.borderColor = UIColor.black.cgColor
        textField.addLeftPadding()
        textField.layer.cornerRadius = 12
        clearButton.isHidden = true
        countLabel.isHidden = true
        completeButton.layer.cornerRadius = 12
        completeButton.backgroundColor = UIColor(red: 0.867, green: 0.867, blue: 0.867, alpha: 1)
        
        descLabel.numberOfLines = 0
        descLabel.setLineHeight(lineHeightMultiple: 1.06)
        descLabel.text = "우주선은 한 기간동안 1대만 가능합니다. \n발사 이후 추가가능합니다."
    }
    
    func prepareKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @objc private func dismissView() {
        self.delegate?.fadein()
        self.dismiss(animated: true)
    }
    
    @IBAction func redRocketTapped(_ sender: Any) {
        redButton.setImage(UIImage(named: "icon_check_rocket_0"), for: .normal)
        
        yellowButton.setImage(UIImage(named: "icon rocket_1"), for: .normal)
        purpleButton.setImage((UIImage(named: "icon rocket_4")), for: .normal)
        blueButton.setImage(UIImage(named: "icon rocket_3"), for: .normal)
        currentRocket = 0
    }
    @IBAction func yellowRocketTapped(_ sender: Any) {
        yellowButton.setImage(UIImage(named: "icon_check_rocket_1"), for: .normal)
        
        redButton.setImage(UIImage(named: "icon rocket_0"), for: .normal)
        purpleButton.setImage((UIImage(named: "icon rocket_4")), for: .normal)
        blueButton.setImage(UIImage(named: "icon rocket_3"), for: .normal)
        currentRocket = 1
    }
    @IBAction func purpleRocketTapped(_ sender: Any) {
        purpleButton.setImage(UIImage(named: "icon_check_rocket_4"), for: .normal)
        
        redButton.setImage(UIImage(named: "icon rocket_0"), for: .normal)
        yellowButton.setImage((UIImage(named: "icon rocket_1")), for: .normal)
        blueButton.setImage(UIImage(named: "icon rocket_3"), for: .normal)
        currentRocket = 4
    }
    @IBAction func blueRocketTapped(_ sender: Any) {
        blueButton.setImage(UIImage(named: "icon_check_rocket_3"), for: .normal)
        
        redButton.setImage(UIImage(named: "icon rocket_0"), for: .normal)
        yellowButton.setImage((UIImage(named: "icon rocket_1")), for: .normal)
        purpleButton.setImage((UIImage(named: "icon rocket_4")), for: .normal)
        currentRocket = 3
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        if let text = textField.text {
            if text.isEmpty == false {
                isActivate = true
                clearButton.isHidden = false
                countLabel.isHidden = false
            } else {
                isActivate = false
                clearButton.isHidden = true
                countLabel.isHidden = true
            }
        }
    }
    @IBAction func clearButtonTapped(_ sender: Any) {
        textField.text = ""
        isActivate = false
        clearButton.isHidden = true
        countLabel.isHidden = true
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            let vc = RocketDateViewController()
            vc.rocketColor = self.currentRocket
            vc.rocketName = self.textField.text
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            pvc.present(vc, animated: true, completion: nil)
        }
    }
    
    
}
extension RocketNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            isActivate = false
        } else {
            isActivate = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        countLabel.text = "\(min(updatedText.count,10))/10"
        return updatedText.count <= 10
    }
}
