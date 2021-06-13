//
//  MainViewController.swift
//  TimeCapsule
//

import UIKit
import SpriteKit
import Lottie
import Alamofire
import KeychainSwift

class MainViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var groundView: UIImageView!
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var fireButton: UIButton!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var rocketListButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    let dataManager = MainDataManager()
    
    let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter
    }()
    
    var currentItems: Int = 0
    var index: Int = 0
    var stones: [Int] = []
    var rocketLaunchFlag = false { // 로켓 발사 여부 flag
        didSet {
            if rocketLaunchFlag == true {
                fireButton.setImage(UIImage(named: "icon_fire"), for: .normal)
                fireButton.removeTarget(self, action: #selector(rocketIsNotReady), for: .touchUpInside)
                fireButton.addTarget(self, action: #selector(fireRocket), for: .touchUpInside)
                addButton.isHidden = true
            } else {
                fireButton.setImage(UIImage(named: "icon_fire_locked"), for: .normal)
                fireButton.removeTarget(self, action: #selector(fireRocket), for: .touchUpInside)
                fireButton.addTarget(self, action: #selector(rocketIsNotReady), for: .touchUpInside)
                addButton.isHidden = false
            }
        }
    }
    
    var rocketListFlag = false { // 로켓 리스트 버튼 화면에 띄우기 여부 flag
        didSet {
            if rocketListFlag == true {
                rocketListButton.isHidden = false
            } else {
                rocketListButton.isHidden = true
            }
        }
    }
    
    var rocketID: Int? // 로켓 아이디
    var rocketColor: Int? // 로켓 색상
    var daysLeft: Double? // 남은 날짜
    var targetDate: String? // 목표 날짜
    
    // 로켓 top 이미지
    lazy var rocketImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "rocket_top_\(self.rocketColor ?? 0)"))
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
    
    // 애니메이션 이미지 - 불꽃
    lazy var fireView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "graphic_fire"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 애니메이션 - 연기
    lazy var smokeAnimationView: AnimationView = {
        let animView = AnimationView(name: "smoke")
        animView.translatesAutoresizingMaskIntoConstraints = false
        animView.contentMode = .scaleAspectFill
        return animView
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
        guard let id = self.rocketID else { return }
        let nextVC = AddWishViewController(rocketID: id, count: currentItems)
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true) { [weak self] in
            guard let self = self else { return}
            let view = self.gameView as! SKView
            view.scene?.removeFromParent()
        }
    }
    
    func setupUI() {
        rocketLaunchFlag = false
        rocketListFlag = false
        
        self.navigationItem.title = ""
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
        
        rocketListButton.layer.zPosition = 10
        rocketListButton.addTarget(self, action: #selector(rocketListButtonTapped), for: .touchUpInside)
        
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
        
        rocketImageView.isHidden = true
        rocketBottomImageView.isHidden = true
        gameView.isHidden = true
        shadowView.isHidden = true
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
    
    func didRetrieveData(rocketID: Int, rocketColor: Int, rocketName: String, launchDate: String, stones: [Int], rocketCount: Int) {
        rocketImageView.isHidden = false
        rocketBottomImageView.isHidden = false
        gameView.isHidden = false
        shadowView.isHidden = false
        
        self.nameLabel.text = rocketName
        self.stones = stones
        self.rocketID = rocketID
        self.rocketColor = rocketColor
        self.rocketImageView.image = UIImage(named: "rocket_top_\(self.rocketColor ?? 0)")
        self.targetDate = launchDate
        self.currentItems = self.stones.count
        self.makeGameScene()
        self.countLabel.text = "\(self.stones.count) / 21"
        
        // 테스트
        //rocketListFlag = true
        
        if rocketCount > 1 {
            rocketListFlag = true
        } else {
            rocketListFlag = false
        }
        
        // 남은 날짜 계산하기
        let today = Date()
        let launch = dateformatter.date(from: launchDate)
        if let dateLaunch = launch {
            daysLeft = today.distance(to: dateLaunch) / 86400
            
            let daysLeftInt = Int(daysLeft?.rounded(.up) ?? 0) // 소수점 올림 처리
            //print("daysLeft: \(daysLeft ?? 0.0)")
            //print("daysLeftInt: \(daysLeftInt)")
            
            // 테스트용
            //rocketLaunchFlag = true
            //self.dayCountLabel.text = "D-DAY"
            
            
            if daysLeftInt == 0 {
                rocketLaunchFlag = true
                self.dayCountLabel.text = "D-DAY"
            } else if daysLeftInt < 0 {
                rocketLaunchFlag = true
                self.dayCountLabel.text = "D+\(-daysLeftInt)"
            } else {
                rocketLaunchFlag = false
                self.dayCountLabel.text = "D-\(daysLeftInt)"
            }
            
        }
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }
    
    @objc fileprivate func rocketIsNotReady() {
        guard let image = UIImage(named: "icon rocket") else { return }
        self.presentBottomAlert(image: image, message: "아직은 발사할 수 없어요")
    }
    
    @objc fileprivate func fireRocket() {
        self.view.addSubview(self.smokeAnimationView)
        self.smokeAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.smokeAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.smokeAnimationView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        self.smokeAnimationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.smokeAnimationView.isHidden = true
        
        self.view.addSubview(self.fireView)
        self.fireView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.fireView.topAnchor.constraint(equalTo: self.rocketImageView.bottomAnchor, constant: -109).isActive = true
        self.fireView.leadingAnchor.constraint(equalTo: self.rocketImageView.leadingAnchor, constant: 90.5).isActive = true
        self.fireView.heightAnchor.constraint(equalToConstant: 317.17).isActive = true
        self.fireView.layer.zPosition = 1
        self.fireView.isHidden = true
        
        let nextVC = EndPopUpViewController(dday: self.dayCountLabel.text ?? "D-DAY", dateString: self.targetDate ?? "", rocketID: self.rocketID ?? 0)
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overCurrentContext
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @objc fileprivate func rocketListButtonTapped() {
        let vc = CompletedRocketViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
            self.countLabel.alpha = 0
            self.dayCountLabel.alpha = 0
            self.nameLabel.alpha = 0
            self.fireButton.alpha = 0
            
            self.rocketImageView.frame.origin = CGPoint(x: self.rocketImageView.frame.origin.x, y: -self.rocketImageView.frame.height)
            self.gameView.frame.origin = CGPoint(x: self.gameView.frame.origin.x, y: -(self.rocketImageView.frame.height/2 + self.gameView.frame.height/2))
            self.rocketBottomImageView.frame.origin = CGPoint(x: self.rocketBottomImageView.frame.origin.x, y: -(self.rocketImageView.frame.height/2 + self.rocketBottomImageView.frame.height/2))
            self.groundView.frame.origin.y += self.groundView.frame.height
            self.shadowView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.fireView.isHidden = false
            self.fireView.frame.origin = CGPoint(x: self.fireView.frame.origin.x, y: -109)
            
            self.smokeAnimationView.isHidden = false
            self.smokeAnimationView.play { (finish) in
                self.smokeAnimationView.removeFromSuperview()
            }
            
        } completion: { [weak self] result in
            print(result.description)
            self?.rocketImageView.removeFromSuperview()
            self?.rocketBottomImageView.removeFromSuperview()
            self?.gameView.removeFromSuperview()
            self?.groundView.removeFromSuperview()
            self?.shadowView.removeFromSuperview()
            self?.fireView.removeFromSuperview()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.moveToIntroVC()
            }
        }
    }
    
    func moveToIntroVC() {
        let introVC = IntroViewController(flag: 1)
        let vc = UINavigationController(rootViewController: introVC)
        self.navigationController?.changeRootViewController(vc)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

protocol ReloadDelegate: AnyObject {
    func reloadView()
    func showToast()
    func endGame()
}
