//
//  EndPopUpViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/13.
//

import UIKit

class EndPopUpViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var completionButton: UIButton!
    
    var delegate: ReloadDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    @IBAction func exitButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completionButtonTapped(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            //코로나 종식 퍼모먼스 레쓰기릿
            self.delegate?.endGame()
        }
    }
    
    func setupUI() {
        containerView.layer.cornerRadius = 30
        containerView.borderWidth = 5
        containerView.borderColor = .black
        
        completionButton.layer.cornerRadius = 8
        completionButton.backgroundColor = UIColor.mainBlack
        completionButton.setTitle("완료", for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.setTitleColor(.white, for: .selected)
 
    }

}
