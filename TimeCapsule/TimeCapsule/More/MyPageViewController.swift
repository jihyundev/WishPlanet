//
//  MyPageViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/04/30.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginTypeLabel: UILabel!
    @IBOutlet weak var loginTypeStackView: UIStackView!
    
    @IBOutlet weak var rocketView: UIView!
    @IBOutlet weak var rocketLabel: UILabel!
    @IBOutlet weak var rocketCountLabel: UILabel!
    
    @IBOutlet weak var wishplanetView: UIView!
    @IBOutlet weak var wishplanetLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let infoTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToMyinfoVC))
        let rocketTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToRocketVC))
        let wishplanetTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToWishplanet))
        self.loginTypeStackView.addGestureRecognizer(infoTapGesture)
        self.rocketView.addGestureRecognizer(rocketTapGesture)
        self.wishplanetView.addGestureRecognizer(wishplanetTapGesture)
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupUI() {
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .main_purple
        titleLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 24)
        nameLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 18)
        loginTypeLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 14)
        rocketLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 15)
        rocketCountLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 14)
        wishplanetLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 15)
        versionLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 11)
        versionLabel.alpha = 0.5
        rocketView.backgroundColor = .main_purple
        wishplanetView.backgroundColor = .main_purple
        rocketView.layer.addBorder([.bottom], color: UIColor(red: 0.455, green: 0.243, blue: 0.914, alpha: 1), width: 1)
    }
    
    @objc fileprivate func moveToMyinfoVC() {
        let vc = MyInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func moveToRocketVC() {
        let vc = MyRocketViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func moveToWishplanet() {
        let vc = WishplanetViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
