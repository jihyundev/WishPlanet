//
//  MainViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import UIKit
import SpriteKit
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var shadowView: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editCapsuleNameButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var capsuleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lockImageView: UIImageView!
    var currentItems: Int = 21
    var index: Int = 0
    var marbles: [Int] = []
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
//        makeGameScene()
        backImageView.contentMode = .scaleAspectFill
        prepareRocket()
        setupUI()
        getAllMarbles()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        getCapsule()
        isCapsuleOpen()
        
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
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let nextVC = AddWishViewController()
        nextVC.delegate = self
        nextVC.count = currentItems
        nextVC.modalPresentationStyle = .overCurrentContext
//        present(nextVC, animated: true, completion: nil)
        present(nextVC, animated: true) { [weak self] in
            guard let self = self else { return}
            let view = self.gameView as! SKView
            view.scene?.removeFromParent()
        }
//        guard let pvc = self.presentingViewController else { return }
//        let nextVC = AddWishViewController()
//        nextVC.modalPresentationStyle = .overCurrentContext
//        self.dismiss(animated: true) {
//            pvc.present(nextVC, animated: true, completion: nil)
//        }
    }
    
    func setupUI() {
        shadowView.isHidden = true
        listButton.layer.cornerRadius = 21
        listButton.borderWidth = 3
        listButton.borderColor = UIColor.init(hex: 0x76FF95)
        listButton.layer.zPosition = 9
        lockImageView.layer.cornerRadius = 21
        lockImageView.backgroundColor = UIColor.init(hex: 0xB4CBF2).withAlphaComponent(0.5)
        lockImageView.layer.zPosition = 10
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
    
    func getCapsule() {
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": Constant.testToken]
        NetworkService.getData(type: .capsuleInfo, headers: headers, parameters: nil) { [weak self] (result: Result<CapsuleInfo,APIError>) in
            guard let self = self else {fatalError()}
            switch result {
            case .success(let model):
                print(model)
                if model.capsuleName == "" {
                    self.nameLabel.text = "로켓 이름"
                } else {
                    self.nameLabel.text = model.capsuleName
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllMarbles() {
        print(#function)
        let headers: HTTPHeaders = ["Accept": "application/json",
            "X-ACCESS-TOKEN": Constant.testToken]
        NetworkService.getData(type: .marbleList, headers: headers, parameters: nil) { [weak self] (result: Result<Marbles,APIError>) in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                self.marbles = []
                model.marbleList.forEach {
                    self.marbles.append($0.marbleColor) }
                self.currentItems = self.marbles.count
                self.makeGameScene()
                self.countLabel.text = ("\(self.marbles.count) / 21")
                print(self.currentItems)
            case .failure(let error):
                print(#function, error.localizedDescription)
            }
        }

    }
    

    
    func isCapsuleOpen() {
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "X-ACCESS-TOKEN": Constant.testToken]
        let url = URLType.capsuleOpen.makeURL
        
        AF.request(url, headers: headers).responseJSON { [weak self] response in
            guard let self = self else { return }
            if let data = response.data {
                if let result = String(data: data, encoding: .utf8), result == "true" {
                    print("코로나 종식")
                    self.listButton.isEnabled = true
                    self.lockImageView.isHidden = true
                    self.addButton.isHidden = true
                    let nextVC = EndPopUpViewController()
                    nextVC.delegate = self
                    nextVC.modalPresentationStyle = .overCurrentContext
                    self.present(nextVC, animated: true, completion: nil)
                } else {
                    print("코로나 중")
                    self.listButton.isEnabled = false
                    self.lockImageView.isHidden = false
                    self.addButton.isHidden = false
                }
            }
        }
    }

}

extension MainViewController: ReloadDelegate {
    func reloadView() {
        let skView = self.gameView as! SKView
        skView.scene?.removeFromParent()
        getAllMarbles()
        isCapsuleOpen()
    }
  
    func reloadName() {
        getCapsule()
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
    func reloadName()
    func endGame()
}
