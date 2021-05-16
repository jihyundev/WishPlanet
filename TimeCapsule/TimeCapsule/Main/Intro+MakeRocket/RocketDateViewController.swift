//
//  RocketDateViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

class RocketDateViewController: UIViewController {
    
    let dataManager = CreateRocketDataManager()
    var selectedDate: String?
    var rocketColor: Int?
    var rocketName: String?

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        containerView.layer.cornerRadius = 24
        containerView.layer.borderWidth = 4
        containerView.layer.borderColor = UIColor.black.cgColor
        completeButton.layer.cornerRadius = 12
        let dateAfterYear = DateHelper.dateAfter(years: 1, from: Date())
        datePicker.date = dateAfterYear!
        let minDate = Date()
        let maxDate = DateHelper.dateAfter(years: 10, from: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    @IBAction func dismissButtonTapped(_ sender: Any) {
        print(#function)
        /*
        guard let pvc = self.presentingViewController else { return }
        self.dismiss(animated: true) {
            let vc = RocketNameViewController()
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            pvc.present(vc, animated: true, completion: nil)
        }
         */
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let date = dateformatter.string(from: datePicker.date)
        //selectedDate = date + " 00:00:00"
        selectedDate = date
        print("selectedDate: ", selectedDate ?? "")
    }
    
    @IBAction func completeButtonTapped(_ sender: Any) {
        guard let date = selectedDate else { return }
        guard let color = rocketColor, let name = rocketName else { return }
        dataManager.postRocket(launchDate: date, rocketColor: color, rocketName: name)
    }
    
}
