//
//  MyPageViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/04/30.
//

import UIKit
import KeychainSwift

class MyPageViewController: UIViewController {
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let dataManager = MoreDataManager()
    
    var currentRocket: MyRocket?
    var launchedRockets: [MyRocket]?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginTypeLabel: UILabel!
    @IBOutlet weak var loginTypeStackView: UIStackView!
    @IBOutlet weak var firstFooterView: UIView!
    
    @IBOutlet weak var rocketView: UIView!
    @IBOutlet weak var rocketLabel: UILabel!
    @IBOutlet weak var rocketCountLabel: UILabel!
    
    @IBOutlet weak var wishplanetView: UIView!
    @IBOutlet weak var wishplanetLabel: UILabel!
    @IBOutlet weak var secondFooterView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.getMoreInfo(viewController: self)
        dataManager.getRocket(viewController: self)
        
        let infoTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToMyinfoVC))
        let rocketTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToRocketVC))
        let wishplanetTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToWishplanet))
        
        self.loginTypeStackView.addGestureRecognizer(infoTapGesture)
        self.rocketView.addGestureRecognizer(rocketTapGesture)
        self.wishplanetView.addGestureRecognizer(wishplanetTapGesture)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.SpoqaHanSansNeo(.bold, size: 15)]
    }
    
    fileprivate func setupUI() {
        self.view.backgroundColor = .mainPurple
        nameLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 18)
        loginTypeLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 14)
        loginTypeLabel.alpha = 0.5
        rocketLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 15)
        rocketCountLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 14)
        wishplanetLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 15)
        versionLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 11)
        versionLabel.alpha = 0.5
        rocketView.backgroundColor = .mainPurple
        wishplanetView.backgroundColor = .mainPurple
        rocketView.layer.addBorder([.bottom], color: UIColor(red: 0.455, green: 0.243, blue: 0.914, alpha: 1), width: 1)
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -30), for: .default)
        
        if let name = keychain.get(Keys.nickname) {
            self.nameLabel.text = name
        } else {
            self.nameLabel.text = ""
        }
        if let socialType = keychain.get(Keys.loginType) {
            self.loginTypeLabel.text = socialType
        } else {
            self.loginTypeLabel.text = ""
        }
        rocketCountLabel.text = ""
        versionLabel.text = ""
        firstFooterView.backgroundColor = UIColor.init(hex: 0x743EE9)
        secondFooterView.backgroundColor = UIColor.init(hex: 0x743EE9)
    }
    
    fileprivate func setNavBar() {
        
        self.title = "더보기"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.SpoqaHanSansNeo(.bold, size: 24)]
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTransparent = true
        
        let backButtonBackgroundImage = UIImage(named: "navigation_bar")
        self.navigationController?.navigationBar.backIndicatorImage = backButtonBackgroundImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
        
    }
    
    @objc fileprivate func moveToMyinfoVC() {
        let vc = MyInfoViewController()
        let name = keychain.get(Keys.nickname)
        vc.name = name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func moveToRocketVC() {
        let vc = MyRocketViewController()
        vc.currentRocket = self.currentRocket ?? MyRocket(rocketID: 0, name: "", period: "", color: 0)
        vc.launchedRockets = self.launchedRockets ?? []
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func moveToWishplanet() {
        let vc = WishplanetViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didRetrieveData(data: GetMoreInfoResponse) {
        self.nameLabel.text = data.nickName
        self.loginTypeLabel.text = data.socialType
        self.rocketCountLabel.text = data.rocketCount
        self.versionLabel.text = "버전정보 \(data.version)"
    }
    
    func didRetrieveRocketData(current: MyRocket, launched: [MyRocket]) {
        self.currentRocket = current
        self.launchedRockets = launched
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }
    
}
