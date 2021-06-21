//
//  CompletedRocketViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/04/18.
//

import UIKit
import SpriteKit

class CompletedRocketViewController: UIViewController {
    
    @IBOutlet weak var gameView: SKView!
    
    var titleText: String = "위시님의 우주선"
    var period: String?
    var days: Int?
    
    var currentItems: Int = 0
    var index: Int = 0
    var stones: [Int] = []
    
    // 로켓 top 이미지
    lazy var rocketImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "rocket_top_fire_0"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 로켓 바닥 이미지
    lazy var rocketBottomImageView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "rocket_bottom"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 로켓 그림자 이미지
    lazy var shadowView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "shadow"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setupUI()
        prepareRocket()
        makeGameScene()
    }
    
    fileprivate func setNavBar() {
        
        self.title = titleText
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
    
    fileprivate func setupUI() {
        self.view.backgroundColor = UIColor(hex: 0x7DB1FF)
    }
    
    func prepareRocket() {
        
        view.addSubview(rocketImageView)
        rocketImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true
        rocketImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        
        rocketImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rocketImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rocketImageView.contentMode = .scaleAspectFit
        print(rocketImageView.frame.size)
        rocketImageView.layer.zPosition = 2
        
        view.addSubview(rocketBottomImageView)
        rocketBottomImageView.leadingAnchor.constraint(equalTo: rocketImageView.leadingAnchor).isActive = true
        rocketBottomImageView.trailingAnchor.constraint(equalTo: rocketImageView.trailingAnchor).isActive = true
        rocketBottomImageView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 0.2926).isActive = true
        rocketBottomImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rocketBottomImageView.contentMode = .scaleAspectFit
        rocketBottomImageView.layer.zPosition = 0
        
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gameView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 218/752).isActive = true
        gameView.widthAnchor.constraint(equalTo: gameView.heightAnchor, multiplier: 20/21).isActive = true
        gameView.layer.zPosition = 1
        
        view.addSubview(shadowView)
        shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: rocketImageView.leadingAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        shadowView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 160/752).isActive = true
        shadowView.contentMode = .scaleAspectFit
        shadowView.layer.zPosition = 1
        
        //rocketImageView.isHidden = true
        //rocketBottomImageView.isHidden = true
        //gameView.isHidden = true
        //shadowView.isHidden = true
    }
    
    func makeGameScene() {
        let scene = GameScene(size: self.gameView.bounds.size)
        let skView = self.gameView!
        scene.currentItemCount = currentItems
        scene.marbles = stones
        
        scene.backgroundColor = .clear
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }

}
