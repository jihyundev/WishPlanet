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
    @IBOutlet weak var shadowView: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editCapsuleNameButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var dayCountLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var capsuleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lockImageView: UIImageView!
    
    let keychain = KeychainSwift(keyPrefix: Keys.keyPrefix)
    
    var currentItems: Int = 21
    var index: Int = 0
    var marbles: [Int] = []
    var rocketLaunchFlag = false
    
    lazy var rocketImageView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "rocket"))
        view.frame.size.width = 300
        view.frame.size.height = 745
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rocketBottomImageView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "rocket_bottom"))
        view.frame.size.width = 213.55
        view.frame.size.height = 205.51
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backImageView.contentMode = .scaleAspectFill
        prepareRocket()
        setupUI()
        getRocket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTransparent = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        isCapsuleOpen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func editCapsuleButtonTapped(_ sender: Any) {
        let nextVC = CapsuleNameViewController()
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overCurrentContext
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func listButtonTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ListViewController") as! ListViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func myPageButtonTapped(_ sender: Any) {
        let mypageVC = MyPageViewController()
        self.navigationController?.pushViewController(mypageVC, animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let nextVC = AddWishViewController()
        nextVC.delegate = self
        nextVC.count = currentItems
        nextVC.modalPresentationStyle = .overCurrentContext
        present(nextVC, animated: true) { [weak self] in
            guard let self = self else { return}
            let view = self.gameView as! SKView
            view.scene?.removeFromParent()
        }
    }
    
    func setupUI() {
        self.navigationItem.title = ""
        shadowView.isHidden = true
        listButton.layer.zPosition = 9
        lockImageView.layer.zPosition = 10
        dayCountLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 10)
        countLabel.layer.cornerRadius = 13.5
        countLabel.layer.masksToBounds = true
        countLabel.backgroundColor = UIColor.init(hex: 0xB4CBF2).withAlphaComponent(0.5)
        countLabel.layer.zPosition = 9
        
        addButton.layer.cornerRadius = 26
        addButton.layer.zPosition = 10
        
        nameLabel.layer.zPosition = 9
        editCapsuleNameButton.layer.zPosition = 9
        
    }
    func prepareRocket() {
        view.addSubview(rocketImageView)
        rocketImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rocketImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        print(rocketImageView.frame.size)
        rocketImageView.layer.zPosition = 2
        gameView.layer.zPosition = 1
        view.addSubview(rocketBottomImageView)
        rocketBottomImageView.leadingAnchor.constraint(equalTo: rocketImageView.leadingAnchor, constant: 47.85).isActive = true
        rocketBottomImageView.bottomAnchor.constraint(equalTo: rocketImageView.bottomAnchor, constant: -266.42).isActive = true
        rocketBottomImageView.layer.zPosition = 0
    }
    
    func makeGameScene() {
        let scene = GameScene(size: self.gameView.bounds.size)
        let skView = self.gameView as! SKView
        scene.currentItemCount = currentItems
        scene.index = index
        scene.marbles = marbles
        
        scene.backgroundColor = .clear
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
    }
    
    func getRocket() {
        guard let token = keychain.get(Keys.token) else { return }
        print("test token: \(Constant.testToken)")
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": token]
        let url = URLType.rocket.makeURL + "?scope=AWAITING&stoneColorCount=true"
        AF.request(url, method: .get, headers: headers, requestModifier: { $0.timeoutInterval = 5 }).validate().responseDecodable(of: [GetRocketsResponse].self) { (response) in
            print("getRocket() called")
            switch response.result {
            case .success(let response):
                print(response)
                let rocket = response[0]
                if rocket.rocketName == "" {
                    self.nameLabel.text = "로켓 이름"
                } else {
                    self.nameLabel.text = rocket.rocketName
                }
                self.marbles = []
                for i in 0..<rocket.stoneColorCount.count {
                    for _ in 0..<rocket.stoneColorCount[i].stoneCount {
                        self.marbles.append(rocket.stoneColorCount[i].stoneColor)
                    }
                }
                self.currentItems = self.marbles.count
                self.makeGameScene()
                self.countLabel.text = ("\(self.marbles.count) / 21")
                print(self.currentItems)
            case .failure(let error):
                print(error.localizedDescription)
                self.presentAlert(title: "서버와의 연결이 원활하지 않습니다. ")
            }
        }
    }
    
    func isCapsuleOpen() {
        if self.rocketLaunchFlag == true {
            self.listButton.isEnabled = true
            self.lockImageView.isHidden = true
            self.addButton.isHidden = true
            let nextVC = EndPopUpViewController()
            nextVC.delegate = self
            nextVC.modalPresentationStyle = .overCurrentContext
            self.present(nextVC, animated: true, completion: nil)
        } else {
            self.listButton.isEnabled = false
            self.lockImageView.isHidden = false
            self.addButton.isHidden = false
        }
    }

}

extension MainViewController: ReloadDelegate {
    func reloadView() {
        let skView = self.gameView as! SKView
        skView.scene?.removeFromParent()
        getRocket()
        isCapsuleOpen()
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
}
