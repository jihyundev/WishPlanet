//
//  GuideViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

class GuideViewController: UIViewController {
    
    var delegate: MovetoRocketNameVCDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var makeRocketButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        containerView.backgroundColor = .mainPurple
        scrollView.backgroundColor = .mainPurple
        descLabel.setLineSpace(spacing: 4)
        descLabel.textAlignment = .center
        descLabel.text = "소원을 이뤄준다는 행성 위시플래닛! \n하고싶은 일들을 흘려보내지 말고, \n소원석에 모두 담아 보관해두고, \n발사 후, 하나씩 이뤄보세요!"
        secondLabel.setLineSpace(spacing: 5)
        secondLabel.text = "하고싶은일, 이루고 싶은 소원들을 \n소원석에 담아요"
        thirdLabel.setLineSpace(spacing: 5)
        thirdLabel.text = "기다리던 그날이 되면, \n우주선을 발사하고 소원을 이루세요."
        makeRocketButton.layer.cornerRadius = makeRocketButton.frame.height / 2
    }
    
    @IBAction func makeRocketButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.moveToRocketNameVC()
        }
        
    }
    

}
