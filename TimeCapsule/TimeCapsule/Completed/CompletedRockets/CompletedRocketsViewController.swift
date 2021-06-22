//
//  CompletedRocketsViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/20.
//

import UIKit
import PanModal

class CompletedRocketsViewController: UIViewController {
    
    private let cellIdentifier = "RocketCollectionViewCell"
    let dataManager = CompletedRocketsDataManager()
    var rockets: [GetRocketsResponse]? = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var rocketLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getCompletedRockets(viewController: self)
        setupUI()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RocketCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavBar()
    }
    
    private func setNavBar() {
        self.navigationController?.navigationBar.isTransparent = true
        self.navigationController?.navigationBar.tintColor = .white
        
        let backButtonBackgroundImage = UIImage(named: "navigation_bar")
        self.navigationController?.navigationBar.backIndicatorImage = backButtonBackgroundImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hex: 0x7DB1FF)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -30), for: .default)
        
        periodLabel.text = ""
        rocketLabel.text = ""
    }
    
    func didRetrieveData(rockets: [GetRocketsResponse]) {
        self.rockets = rockets
        collectionView.reloadData()
        periodLabel.text = "\(rockets[0].createdAt) ~ \(rockets[0].launchDate)"
        rocketLabel.text = rockets[0].rocketName
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }
}
// MARK: - UICollectionViewDataSource
extension CompletedRocketsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rockets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? RocketCollectionViewCell
        if let rocket = rockets?[indexPath.item] {
            var stones: [Int] = []
            if let stoneList = rocket.stoneColorCount {
                for i in 0..<stoneList.count {
                    for _ in 0..<stoneList[i].stoneCount {
                        stones.append(stoneList[i].stoneColor)
                    }
                }
            }
            cell?.configure(color: rocket.rocketColor, currentItems: stones.count, stones: stones)
        }
        cell?.backgroundColor = .clear
        
        return cell ?? UICollectionViewCell()
    }
    
}

// MARK: UICollectionViewDelegate
extension CompletedRocketsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("LOG - current index: \(indexPath.item)")
        print("LOG - rocketID: \(rockets?[indexPath.item].rocketID ?? 0)")
        let listVC = CompletedListViewController(rocketID: rockets?[indexPath.item].rocketID ?? 0)
        self.presentPanModal(listVC)
        //self.present(listVC, animated: true, completion: nil)
    }
    
    // 스크롤할 때 해당 collection view의 인덱스 도출, label 변경
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / view.frame.width))
        let periodText = "\(rockets?[pageIndex].createdAt ?? "") ~ \(rockets?[pageIndex].launchDate ?? "")"
        periodLabel.text = periodText
        rocketLabel.text = rockets?[pageIndex].rocketName
    }
}

// MARK: UICollectionViewLayout
extension CompletedRocketsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        return size
    }
}
