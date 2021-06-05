//
//  MyRocketEditViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/04.
//

import UIKit

class MyRocketEditViewController: UIViewController {
    
    private let titleString: String?
    
    let datePicker = UIDatePicker()
    let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter
    }()
    
    var rocketColor: Int? // 우주선 색
    var rocketName: String? // 로켓 이름
    var originalDate: String? // 기존 발사일
    var selectedDate: String? // 수정한 발사일
    
    init(titleString: String) {
        self.titleString = titleString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconStarImageView: UIImageView!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createDatePicker()
        prepareKeyboard()
        self.dismissKeyboardWhenTappedAround()
        nameTextField.delegate = self
        dateTextField.delegate = self
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = .mainPurple
        self.title = titleString
        iconImageView.image = UIImage(named: "icon rocket_\(self.rocketColor ?? 0)")
        nameTextField.layer.backgroundColor = UIColor.init(hex: 0x743EE9).cgColor
        nameTextField.textColor = .white
        nameTextField.text = rocketName
        nameTextField.layer.cornerRadius = 12
        nameTextField.addLeftPadding()
        nameTextField.returnKeyType = .done
        dateTextField.layer.backgroundColor = UIColor.init(hex: 0x743EE9).cgColor
        dateTextField.textColor = .white
        dateTextField.text = originalDate
        dateTextField.layer.cornerRadius = 12
        dateTextField.addLeftPadding()
        dateTextField.returnKeyType = .done
        clearButton.isHidden = true
        textCountLabel.isHidden = true
        footerView.backgroundColor = UIColor.init(hex: 0x743EE9)
    }
    
    func prepareKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification{
            view.frame.origin.y = -keyboardFrame.height / 3
            iconImageView.isHidden = true
            iconStarImageView.isHidden = true
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            view.frame.origin.y = 0
            iconImageView.isHidden = false
            iconStarImageView.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func createDatePicker() {
        datePicker.date = Date()
        let minDate = Date(timeIntervalSinceNow: 86400)
        let maxDate = DateHelper.dateAfter(years: 10, from: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.backgroundColor = .white
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = .white
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: nil, action: #selector(donePressed))
        doneButton.tintColor = .mainPurple
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        dateTextField.inputView?.backgroundColor = .white
    }
    
    @objc func donePressed() {
        dateTextField.resignFirstResponder()
        
        let date = dateformatter.string(from: datePicker.date)
        selectedDate = date
        dateTextField.text = date
        print("selectedDate: ", selectedDate ?? "")
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        let date = dateformatter.string(from: picker.date)
        selectedDate = date
        dateTextField.text = date
        print("selectedDate: ", selectedDate ?? "")
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        nameTextField.text = ""
        textCountLabel.text = "0/10"
        clearButton.isHidden = true
    }
    
    @IBAction func nameEditingChanged(_ sender: Any) {
        if nameTextField.text?.isEmpty == true {
            clearButton.isHidden = true
            textCountLabel.isHidden = true
        } else {
            clearButton.isHidden = false
            textCountLabel.isHidden = false
        }
    }
    
    @IBAction func datePickerButtonTapped(_ sender: Any) {
        dateTextField.becomeFirstResponder()
    }
    

}

extension MyRocketEditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        textCountLabel.text = "\(min(updatedText.count,10))/10"
        return updatedText.count <= 10
    }
}
