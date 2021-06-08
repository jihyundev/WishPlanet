//
//  MyRocketEditViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/04.
//

import UIKit

class MyRocketEditViewController: UIViewController {
    
    private let titleString: String
    private let rocketID: Int // 로켓 아이디
    
    let datePicker = UIDatePicker()
    let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter
    }()
    let dataManager = MyRocketEditDataManager()
    
    // 우주선 색
    var rocketColor: Int = 0 {
        didSet { iconImageView.image = UIImage(named: "icon rocket_\(self.rocketColor )") }
    }
    // 로켓 이름
    var rocketName: String = "" {
        didSet { nameTextField.text = rocketName }
    }
    
    var originalDate: String // 기존 발사일
    var selectedDate: String? // 수정한 발사일
    weak var delegate: ReloadRocketDetailDelegate?
    
    lazy var completeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completeButtonPressed(_:)))
        button.setTitleTextAttributes([.font: UIFont.SpoqaHanSansNeo(.medium, size: 15)], for: .normal)
        return button
    }()
    
    init(titleString: String, rocketID: Int, originalDate: String) {
        self.titleString = titleString
        self.rocketID = rocketID
        self.originalDate = originalDate
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
    @IBOutlet weak var datePickerButton: UIButton!
    @IBOutlet weak var editedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("rocketID:\(self.rocketID)")
        dataManager.getRocketDetails(rocketID: rocketID, viewController: self)
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
        datePickerButton.isHidden = true
        editedLabel.isHidden = true
        iconImageView.image = UIImage(named: "icon rocket_\(self.rocketColor )")
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
        
        self.navigationItem.rightBarButtonItem = self.completeButton
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
        datePicker.date = dateformatter.date(from: originalDate) ?? Date()
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
    
    // 우주선 수정 완료 버튼 Handler
    @objc private func completeButtonPressed(_ sender: Any) {
        if let name = nameTextField.text, let date = dateTextField.text {
            print("name: \(name), date: \(date)")
            dataManager.patchRocketDetails(rocketID: rocketID, name: name, date: date, viewController: self)
        }
    }
    
    func didRetrieveData(rocketColor: Int, name: String, date: String, canPatch: Bool) {
        self.rocketColor = rocketColor
        self.rocketName = name
        dateTextField.text = date
        if canPatch == false {
            // 버튼 가리기 + 텍스트필드 수정 불가능 + 수정됨 Label 생성
            datePickerButton.isHidden = true
            dateTextField.isUserInteractionEnabled = false
            editedLabel.isHidden = false
        } else {
            datePickerButton.isHidden = false
            dateTextField.isUserInteractionEnabled = true
            editedLabel.isHidden = true
        }
    }
    
    func successToPatch() {
        // 데이터 업데이트 후 pop
        delegate?.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
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
