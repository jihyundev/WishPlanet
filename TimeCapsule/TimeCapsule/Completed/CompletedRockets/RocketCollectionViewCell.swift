//
//  RocketCollectionViewCell.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/20.
//

import UIKit

class RocketCollectionViewCell: UICollectionViewCell {
    
    var color: Int?
    
    lazy var rocketImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "rocket_top_0"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topImageContainerView.addSubview(rocketImageView)
        
        rocketImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        rocketImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        rocketImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
}
