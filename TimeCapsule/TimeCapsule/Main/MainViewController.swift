//
//  MainViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import UIKit
import SpriteKit
import Alamofire
import KeychainSwift

class MainViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var dayCountLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let dataManager = MainDataManager()
    let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter
    }()
    
    var currentItems: Int = 21
    var index: Int = 0
    var stones: [Int] = []
    var rocketLaunchFlag = false {
        didSet {
            if rocketLaunchFlag == true {
                listButton.setImage(UIImage(named: "icon_fire"), for: .normal)
                listButton.addTarget(self, action: #selector(fireRocket), for: .touchUpInside)
                addButton.isHidden = true
            } else {
                listButton.setImage(UIImage(named: "icon_fire_locked"), for: .normal)
                listButton.addTarget(self, action: #selector(rocketIsNotReady), for: .touchUpInside)
                addButton.isHidden = false
            }
        }
    }
    
    var rocketID: Int?
    var rocketColor: Int?
    var daysLeft: Double?
    
    lazy var rocketImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "rocket_top_\(self.rocketColor ?? 0)"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rocketBottomImageView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "rocket_bottom"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var shadowView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "shadow"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getRocket(viewController: self)
        backImageView.contentMode = .scaleAspectFill
        prepareRocket()
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
    
    @IBAction func myPageButtonTapped(_ sender: Any) {
        let mypageVC = MyPageViewController()
        self.navigationController?.pushViewController(mypageVC, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let nextVC = AddWishViewController()
        nextVC.delegate = self
        nextVC.rocketID = self.rocketID
        nextVC.count = currentItems
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true) { [weak self] in
            guard let self = self else { return}
            let view = self.gameView as! SKView
            view.scene?.removeFromParent()
        }
    }
    
    func setupUI() {
        self.navigationItem.title = ""
        //listButton.layer.zPosition = 9
        dayCountLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 10)
        countLabel.layer.cornerRadius = 13.5
        countLabel.layer.masksToBounds = true
        countLabel.backgroundColor = UIColor.init(hex: 0xB4CBF2).withAlphaComponent(0.5)
        countLabel.layer.zPosition = 9
        
        addButton.layer.cornerRadius = 26
        addButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        addButton.layer.shadowOpacity = 1.0
        addButton.layer.shadowRadius = 10
        addButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        addButton.layer.zPosition = 10
        
        nameLabel.layer.zPosition = 9
        
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
    }
    
    func makeGameScene() {
        let scene = GameScene(size: self.gameView.bounds.size)
        let skView = self.gameView as! SKView
        scene.currentItemCount = currentItems
        scene.index = index
        scene.marbles = stones
        
        scene.backgroundColor = .clear
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
    
    func didRetrieveData(rocketID: Int, rocketColor: Int, rocketName: String, launchDate: String, stones: [Int]) {
        self.nameLabel.text = rocketName
        self.stones = stones
        self.rocketID = rocketID
        self.rocketColor = rocketColor
        self.currentItems = self.stones.count
        self.makeGameScene()
        self.countLabel.text = "\(self.stones.count) / 21"
        // 남은 날짜 계산하기
        let today = Date()
        let launch = dateformatter.date(from: launchDate)
        if let dateLaunch = launch {
            daysLeft = today.distance(to: dateLaunch) / 86400
            if daysLeft == 0.0 {
                rocketLaunchFlag = true
                self.dayCountLabel.text = "D-DAY"
            } else {
                rocketLaunchFlag = false
                self.dayCountLabel.text = "D-\(Int(daysLeft ?? 0))"
            }
        }
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }
    
    @objc fileprivate func rocketIsNotReady() {
        guard let image = UIImage(named: "icon_rocket") else { return }
        self.presentBottomAlert(image: image, message: "아직은 발사할 수 없어요")
    }
    
    @objc fileprivate func fireRocket() {
        let nextVC = EndPopUpViewController()
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func showToast(_ sender: Any) {
        guard let image = UIImage(named: "icon_success") else { return }
        let stoneLeft = 21 - self.stones.count
        self.presentBottomAlert(image: image, message: "소원석 추가 성공!", desc: "\(stoneLeft)개 남음")
    }
    

}

extension MainViewController: ReloadDelegate {
    func showToast() {
        guard let image = UIImage(named: "icon_success") else { return }
        let stoneLeft = 21 - self.stones.count
        self.presentBottomAlert(image: image, message: "소원석 추가 성공!", desc: "\(stoneLeft)개 남음")
    }
    
    func reloadView() {
        let skView = self.gameView as! SKView
        skView.scene?.removeFromParent()
        dataManager.getRocket(viewController: self)
    }
     
    func endGame() {
        
        UIView.animate(withDuration: 5, delay: 0, options: .curveEaseIn) {
            print(self.rocketImageView.frame.origin.y, self.gameView.frame.origin.y)
            print(self.rocketBottomImageView.frame.origin.y)
            self.rocketImageView.frame.origin = CGPoint(x: self.rocketImageView.frame.origin.x, y: -1100)
            self.gameView.frame.origin = CGPoint(x: self.gameView.frame.origin.x, y: -831)
            self.rocketBottomImageView.frame.origin = CGPoint(x: self.gameView.frame.origin.x, y: -801.33333)

        } completion: { result in
            print(result.description)
        }

    }
}

protocol ReloadDelegate {
    func reloadView()
    func endGame()
    func showToast()
}
