//
//  RocketCollectionViewCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/20.
//

import UIKit
import SpriteKit

class RocketCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RocketCollectionViewCell"
    
    var rocketColor: Int = 0 // 로켓 색상
    
    // 로켓 top 이미지
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("RocketCollectionViewCell - prepareForReuse() called")
    }
    
    
    private func setupLayout() {
        print("RocketCollectionViewCell - setupLayout() called")
        contentView.addSubview(rocketImageView)
        rocketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22).isActive = true
        rocketImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        rocketImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        rocketImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rocketImageView.contentMode = .scaleAspectFit
        //print(rocketImageView.frame.size)
        rocketImageView.layer.zPosition = 2
        
        contentView.addSubview(rocketBottomImageView)
        rocketBottomImageView.leadingAnchor.constraint(equalTo: rocketImageView.leadingAnchor).isActive = true
        rocketBottomImageView.trailingAnchor.constraint(equalTo: rocketImageView.trailingAnchor).isActive = true
        rocketBottomImageView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 0.2926).isActive = true
        rocketBottomImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rocketBottomImageView.contentMode = .scaleAspectFit
        rocketBottomImageView.layer.zPosition = 0
        
        contentView.addSubview(shadowView)
        shadowView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: rocketImageView.leadingAnchor).isActive = true
        shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        shadowView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 160/752).isActive = true
        shadowView.contentMode = .scaleAspectFit
        shadowView.layer.zPosition = 1
        
        contentView.addSubview(gameView)
        gameView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        gameView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        gameView.heightAnchor.constraint(equalTo: rocketImageView.heightAnchor, multiplier: 218/752).isActive = true
        gameView.widthAnchor.constraint(equalTo: gameView.heightAnchor, multiplier: 20/21).isActive = true
        gameView.layer.zPosition = 1
    }
    
    func makeGameScene(currentItems: Int, stones: [Int]) {
        print("RocketCollectionViewCell - makeGameScene() called")
        let scene = GameScene(size: self.gameView.bounds.size)
        let skView = self.gameView as SKView
        scene.currentItemCount = currentItems
        scene.marbles = stones
        print("LOG - currentItems: \(currentItems)")
        print("LOG - stones: \(stones)")
        scene.backgroundColor = .systemBlue
        skView.ignoresSiblingOrder = true
        //gameView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFit
        skView.presentScene(scene)
        //gameView.presentScene(scene)
        print("RocketCollectionViewCell - makeGameScene() finished")
    }
    
    func configure(color: Int, currentItems: Int, stones: [Int]) {
        rocketImageView.image = UIImage(named: "rocket_top_fire_\(color)")
        makeGameScene(currentItems: currentItems, stones: stones)
    }
    
    deinit {
        print("RocketCollectionViewCell - deinit() called")
    }
}
