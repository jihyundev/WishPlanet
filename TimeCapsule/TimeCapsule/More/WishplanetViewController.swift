//
//  WishplanetViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/05/06.
//

import UIKit

class WishplanetViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var container1: UIView!
    @IBOutlet weak var container2: UIView!
    @IBOutlet weak var container3: UIView!
    @IBOutlet weak var container4: UIView!
    @IBOutlet weak var container5: UIView!
    
    @IBOutlet weak var opensourceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setupUI()
        
        let opensourceTapGesture = UITapGestureRecognizer(target: self, action: #selector(opensourceTapped))
        opensourceView.addGestureRecognizer(opensourceTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTransparent = true
    }
    
    fileprivate func setupUI() {
        self.title = ""
        self.view.backgroundColor = .mainPurple
        container1.backgroundColor = .mainPurple
        container2.backgroundColor = .mainPurple
        container3.backgroundColor = .mainPurple
        container4.backgroundColor = .mainPurple
        container5.backgroundColor = .mainPurple
        opensourceView.backgroundColor = .mainPurple
        
        if UIScreen.main.bounds.size.width > 380 {
            descLabel.text = "위시플래닛은 \n하고싶은 일, 이루고 싶은 소원들wish을 \n지금은 아닌, 미지의 먼 미래 (미지의 우주 - 행성 planet)에 \n할 수 있도록 미리 담아두는 타임캡슐 서비스 입니다."
        } else {
            descLabel.text = "위시플래닛은 \n하고싶은 일, 이루고 싶은 소원들wish을 \n지금은 아닌, 미지의 먼 미래 (미지의 우주 - 행성 planet)에 할 수 있도록 미리 담아두는 타임캡슐 서비스 입니다."
        }
        
        descLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 14)
        descLabel.makeBold(targetString: "위시플래닛")
        descLabel.setLineHeight(lineHeightMultiple: 1.31)
        
        subLabel.text = "위시플래닛이 사용자들의 소원이 이뤄질 수 있도록 \n함께 응원하겠습니다."
        subLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 14)
        subLabel.setLineHeight(lineHeightMultiple: 1.31)
    }
    
    @IBAction func opensourceButtonTapped(_ sender: Any) {
        let vc = OpenSourceViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func opensourceTapped() {
        let vc = OpenSourceViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
extension WishplanetViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
}
