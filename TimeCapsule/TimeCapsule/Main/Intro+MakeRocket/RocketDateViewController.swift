//
//  RocketDateViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

class RocketDateViewController: UIViewController {
    
    let dataManager = CreateRocketDataManager()
    let datePicker = UIDatePicker()
    let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        return dateformatter
    }()
    
    var delegate: IntroFadeAnimationDelegate?
    var selectedDate: String?
    var rocketColor: Int?
    var rocketName: String?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var centerY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createDatePicker()
        prepareKeyboard()
        self.dismissKeyboardWhenTappedAround()
    }
    
    fileprivate func setupUI() {
        containerView.layer.cornerRadius = 24
        containerView.layer.borderWidth = 4
        containerView.layer.borderColor = UIColor.black.cgColor
        completeButton.layer.cornerRadius = 12
        textField.addLeftPadding()
        textField.layer.cornerRadius = 12
        textField.font = UIFont.SpoqaHanSansNeo(.bold, size: 16)
        textField.tintColor = .clear
        
        let dateAfterYear = DateHelper.dateAfter(years: 1, from: Date())
        let date = dateformatter.string(from: dateAfterYear!)
        selectedDate = date
        textField.text = date
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
    
    @objc private func dismissView() {
        NotificationCenter.default.post(name: Notification.Name("FadeInIntroVC"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func createDatePicker() {
        let dateAfterYear = DateHelper.dateAfter(years: 1, from: Date())
        datePicker.date = dateAfterYear!
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
        
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        textField.inputView?.backgroundColor = .white
    }
    
    @objc func donePressed() {
        textField.resignFirstResponder()
        
        let date = dateformatter.string(from: datePicker.date)
        selectedDate = date
        textField.text = date
        print("selectedDate: ", selectedDate ?? "")
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        let date = dateformatter.string(from: picker.date)
        selectedDate = date
        textField.text = date
        print("selectedDate: ", selectedDate ?? "")
    }
    
    @IBAction func datePickerButtonTapped(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        guard let date = selectedDate else { return }
        guard let color = rocketColor, let name = rocketName else { return }
        dataManager.postRocket(launchDate: date, rocketColor: color, rocketName: name, viewController: self)
        self.showIndicator()
    }
    
    func didSuccessToPost() {
        self.dismissIndicator()
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            let mainVC = MainViewController()
            let vc = UINavigationController(rootViewController: mainVC)
            vc.modalPresentationStyle = .fullScreen
            pvc.present(vc, animated: true, completion: nil)
        }
    }
    
    func failedToPost() {
        self.dismissIndicator()
        self.presentAlert(title: "서버와의 연결이 원활하지 않습니다. ", isCancelActionIncluded: false)
    }
    
}
