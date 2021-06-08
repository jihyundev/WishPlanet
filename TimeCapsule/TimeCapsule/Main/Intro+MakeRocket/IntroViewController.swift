//
//  IntroViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/07.
//

import UIKit

class IntroViewController: UIViewController {
    
    private var flag: Int // 소개화면: 0, 우주선 재생성 화면: 1
    
    init(flag: Int) {
        self.flag = flag
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var guideButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var dolImageView: UIImageView!
    @IBOutlet weak var rocketDescLabel: UILabel!
    @IBOutlet weak var makeRocketButton: UIButton!
    
    @IBOutlet weak var rocketListButton: UIButton!
    @IBOutlet weak var rocketListToast: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        verifyFlag()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTransparent = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(fadein), name: Notification.Name("FadeInIntroVC"), object: nil)
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
    
    fileprivate func verifyFlag() {
        if flag == 0 {
            rocketListToast.isHidden = true
            rocketListButton.isHidden = true
        } else {
            mainLabel.isHidden = true
            subLabel.isHidden = true
            guideButton.isHidden = true
            UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
                self.rocketListToast.alpha = 0
            }.startAnimation(afterDelay: 5)
        }
    }
    
    @IBAction func guideButtonTapped(_ sender: Any) {
        let vc = GuideViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func makeRocketButtonTapped(_ sender: Any) {
        moveToRocketNameVC()
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        let mypageVC = MyPageViewController()
        self.navigationController?.pushViewController(mypageVC, animated: true)
    }
    
}

extension IntroViewController: IntroFadeAnimationDelegate, MovetoRocketNameVCDelegate {
    
    func moveToRocketNameVC() {
        self.fadeout()
        let nameVC = RocketNameViewController()
        nameVC.delegate = self
        nameVC.modalPresentationStyle = .overCurrentContext
        nameVC.modalTransitionStyle = .crossDissolve
        self.present(nameVC, animated: true, completion: nil)
    }
    
    func fadeout() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.mainLabel.alpha = 0
            self.subLabel.alpha = 0
            self.guideButton.alpha = 0
            self.moreButton.alpha = 0
            self.dolImageView.alpha = 0
            self.rocketDescLabel.alpha = 0
            self.makeRocketButton.alpha = 0
            
            self.rocketListButton.alpha = 0
        }.startAnimation()
    }
    
    @objc
    func fadein() {
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.mainLabel.alpha = 1
            self.subLabel.alpha = 1
            self.guideButton.alpha = 1
            self.moreButton.alpha = 1
            self.dolImageView.alpha = 1
            self.rocketDescLabel.alpha = 1
            self.makeRocketButton.alpha = 1
            
            self.rocketListButton.alpha = 1
        }.startAnimation()
    }
}

protocol IntroFadeAnimationDelegate: AnyObject {
    func fadeout()
    func fadein()
}
protocol MovetoRocketNameVCDelegate: AnyObject {
    func moveToRocketNameVC()
}
