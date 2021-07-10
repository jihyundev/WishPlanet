//
//  NicknameEditViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import UIKit
import KeychainSwift

class NicknameEditViewController: UIViewController {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let dataManager = MyInfoDataManager()
    var nickname: String?
    var delegate: ReloadNicknameDelegate?
    
    lazy var completeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonPressed(_:)))
        button.setTitleTextAttributes([.font: UIFont.SpoqaHanSansNeo(.medium, size: 15)], for: .normal)
        return button
    }()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.nameTextField.text = nickname
        self.dismissKeyboardWhenTappedAround()
        self.nameTextField.delegate = self
    }
    
    fileprivate func setupUI() {
        self.title = "닉네임 수정"
        self.nickname = keychain.get(Keys.nickname)
        self.view.backgroundColor = .mainPurple
        self.nameTextField.cornerRadius = 12
        self.nameTextField.borderStyle = .none
        self.nameTextField.addLeftPadding()
        self.nameTextField.returnKeyType = .done
        if let name = self.nickname {
            self.textCountLabel.text = "\(name.count)/10"
        } else {
            self.textCountLabel.text = "0/10"
        }
        
        
        self.navigationItem.rightBarButtonItem = self.completeButton
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        nameTextField.text = ""
        self.textCountLabel.text = "0/10"
    }
    
    @IBAction func nameTextFieldEditingChanged(_ sender: Any) {
        if nameTextField.text?.isEmpty == true {
            clearButton.isHidden = true
            textCountLabel.isHidden = true
        } else {
            clearButton.isHidden = false
            textCountLabel.isHidden = false
        }
    }
    
    @objc private func completeButtonPressed(_ sender: Any) {
        guard let name = self.nickname else { return }
        dataManager.patchNickname(nickname: name, viewController: self)
    }
    
    func didRetreiveData() {
        self.presentAlert(title: "닉네임 변경에 성공하였습니다. ") {_ in
            self.delegate?.updateNickname()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension NicknameEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        self.textCountLabel.text = "\(min(updatedText.count,10))/10"
        return updatedText.count <= 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = self.nameTextField.text else { return }
        self.nickname = name
        clearButton.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if nameTextField.text?.isEmpty == true {
            clearButton.isHidden = true
            textCountLabel.isHidden = true
        } else {
            clearButton.isHidden = false
            textCountLabel.isHidden = false
        }
    }
    
}
