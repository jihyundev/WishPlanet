//
//  MyLaunchedRocketViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/07/11.
//

import UIKit
import SpriteKit
import PanModal

class MyLaunchedRocketViewController: UIViewController {
    
    let dataManager = MyRocketDataManager()
    private let rocketID: Int
    
    init(rocketID: Int) {
        self.rocketID = rocketID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rocketColor = 0 {
        didSet {
            rocketImageView.image = UIImage(named: "rocket_top_fire_\(rocketColor)")
        }
    }
    
    lazy var rocketImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "rocket_top_fire_\(rocketColor)"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 로켓 바닥 이미지
    let rocketBottomImageView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "rocket_bottom"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 로켓 그림자 이미지
    let shadowView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "shadow"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 로켓 내부 Game View
    let gameView: SKView = {
        let view = SKView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @IBOutlet weak var rocketLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("rocketID: \(rocketID)")
        setupUI()
        prepareRocket()
        dataManager.getLaunchedRocket(rocketID: self.rocketID, viewController: self)
        
        let rocketTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapRocket(_:)))
        view.addGestureRecognizer(rocketTapGestureRecognizer)
        
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: 0x7DB1FF)
        periodLabel.text = ""
        rocketLabel.text = ""
        periodLabel.layer.zPosition = 3
        rocketLabel.layer.zPosition = 3
    }
    
    private func prepareRocket() {
        view.addSubview(rocketImageView)
        rocketImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true
        rocketImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        rocketImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rocketImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rocketImageView.contentMode = .scaleAspectFit
        rocketImageView.layer.zPosition = 2
        
        view.addSubview(rocketBottomImageView)
        rocketBottomImageView.leadingAnchor.constraint(equalTo: rocketImageView.leadingAnchor).isActive = true
        rocketBottomImageView.trailingAnchor.constraint(equalTo: rocketImageView.trailingAnchor).isActive = true
        rocketBottomImageView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 0.2926).isActive = true
        rocketBottomImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rocketBottomImageView.contentMode = .scaleAspectFit
        rocketBottomImageView.layer.zPosition = 0
        
        view.addSubview(shadowView)
        shadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: rocketImageView.leadingAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        shadowView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 160/752).isActive = true
        shadowView.contentMode = .scaleAspectFit
        shadowView.layer.zPosition = 1
        
        view.addSubview(gameView)
        gameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        gameView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 218/752).isActive = true
        gameView.widthAnchor.constraint(equalTo: gameView.heightAnchor, multiplier: 20/21).isActive = true
        gameView.layer.zPosition = 1
        
        [rocketImageView, rocketBottomImageView, gameView, shadowView].forEach {
            $0?.isHidden = true
        }
        
    }
    
    func makeGameScene(currentItems: Int, stones: [Int]) {
        let scene = GameScene(size: self.gameView.bounds.size)
        let skView = self.gameView as SKView
        scene.currentItemCount = currentItems
        scene.marbles = stones
        
        scene.backgroundColor = .clear
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
    
    @objc func didTapRocket(_ sender: UITapGestureRecognizer) {
        let listVC = CompletedListViewController(rocketID: rocketID)
        self.presentPanModal(listVC)
        
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.isToggledRocket)
    }
    
    func didRetrieveData(rocketResponse: GetRocketsResponse, stones: [Int]) {
        [rocketImageView, rocketBottomImageView, gameView, shadowView].forEach {
            $0?.isHidden = false
        }
        self.rocketLabel.text = rocketResponse.rocketName
        
        let createdAtString = DateHelper.switchDateformat(dateString: rocketResponse.createdAt)
        let launchDateString = DateHelper.switchDateformat(dateString: rocketResponse.launchDate)
        let interval = DateHelper.numberOfDaysBetween(fromDateString: createdAtString, toDateString: launchDateString)
        
        self.periodLabel.text = "\(createdAtString) ~ \(launchDateString)  \(interval)일"
        self.rocketColor = rocketResponse.rocketColor
        makeGameScene(currentItems: stones.count, stones: stones)
        
        let isToggled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isToggledRocket)
        if !isToggled {
            self.presentCenterAlert(message: "누르면 내역을 볼 수 있어요!")
        }
        
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message, isCancelActionIncluded: false) {_ in 
            self.navigationController?.popViewController(animated: true)
        }
    }

}
