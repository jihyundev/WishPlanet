//
//  RocketCollectionViewCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/20.
//

import UIKit

class RocketCollectionViewCell: UICollectionViewCell {
    
    var color: Int = 0
    
    // 로켓 top 이미지
    lazy var rocketImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "rocket_top_fire_\(color)"))
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(rocketImageView)
        rocketImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22).isActive = true
        rocketImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        rocketImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        rocketImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rocketImageView.contentMode = .scaleAspectFit
        print(rocketImageView.frame.size)
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
    }
    
    func configure(color: Int) {
        rocketImageView.image = UIImage(named: "rocket_top_fire_\(color)")
    }
}
