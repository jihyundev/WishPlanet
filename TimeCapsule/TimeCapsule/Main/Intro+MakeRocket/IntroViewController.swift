//
//  IntroViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var guideButton: UIButton!
    @IBOutlet weak var makeRocketButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTransparent = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    fileprivate func setupUI() {
        self.navigationItem.title = ""
        mainLabel.setLineSpace(spacing: 5)
        mainLabel.text = "위시플래닛에 \n오신 걸 환영합니다!"
        mainLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 26)
        subLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 16)
        guideButton.layer.cornerRadius = 12
        guideButton.backgroundColor = UIColor.graphic.withAlphaComponent(0.5)
        guideButton.setTitle("가이드보기", for: .normal)
        guideButton.setTitleColor(.white, for: .normal)
        guideButton.titleLabel?.font = UIFont.SpoqaHanSansNeo(.bold, size: 12)
        
        makeRocketButton.layer.cornerRadius = makeRocketButton.frame.height / 2
        makeRocketButton.backgroundColor = .mainPurple
    }
    
    @IBAction func guideButtonTapped(_ sender: Any) {
        let vc = GuideViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func makeRocketButtonTapped(_ sender: Any) {
        let vc = RocketNameViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func moreButtonTapped(_ sender: Any) {
        let mypageVC = MyPageViewController()
        self.navigationController?.pushViewController(mypageVC, animated: true)
    }
    
}
