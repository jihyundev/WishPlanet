//
//  UITableView.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/04.
//

import UIKit

extension UITableView {
    
    // 우주선 추가화면 테이블 뷰 placeholder 생성
    func setEmptyRocketView() {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let imageView = UIImageView()
        let messageLabel = UILabel()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 13)
        messageLabel.textColor = .white
        messageLabel.alpha = 0.7
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(messageLabel)
        emptyView.backgroundColor = .mainPurple
        
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -200).isActive = true
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        imageView.image = UIImage(named: "smalldol_1")
        messageLabel.text = "아직 우주선이 없어요"
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
        
    }
    
    func setEmptyStoneView() {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let imageView = UIImageView()
        let messageLabel = UILabel()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 13)
        messageLabel.textColor = .white
        messageLabel.alpha = 0.7
        
        emptyView.addSubview(imageView)
        emptyView.addSubview(messageLabel)
        emptyView.backgroundColor = .mainPurple
        
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -50).isActive = true
        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        imageView.image = UIImage(named: "smalldol_1")
        messageLabel.text = "추가한 소원석이 없어요"
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
        
    }
    
    func restoreWithLine() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
    func restoreWithoutLine() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
}
