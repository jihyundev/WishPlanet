//
//  LaunchedRocketsViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/08/22.
//

import UIKit

class LaunchedRocketsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dataManager = LaunchedRocketsDataManager()
    var rockets: [GetRocketsResponse]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.getCompletedRockets(viewController: self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "LaunchedRocketsCell", bundle: nil), forCellWithReuseIdentifier: LaunchedRocketsCell.identifier)
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.title = ""
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        collectionView.backgroundColor = .clear
        view.backgroundColor = .popupViolet
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -30), for: .default)
    }
    
    private func setNavBar() {
        self.title = "착륙 우주선"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.SpoqaHanSansNeo(.bold, size: 24)]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.SpoqaHanSansNeo(.bold, size: 15)]
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.isTransparent = true
        self.navigationController?.navigationBar.layoutMargins.left = 22
        self.navigationController?.navigationBar.layoutMargins.top = 16
        
        let backButtonBackgroundImage = UIImage(named: "navigation_bar")
        self.navigationController?.navigationBar.backIndicatorImage = backButtonBackgroundImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonBackgroundImage
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
    }
    
    func didRetrieveData(rockets: [GetRocketsResponse]) {
        self.rockets = rockets
        collectionView.reloadData()
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }

}
extension LaunchedRocketsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rockets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchedRocketsCell.identifier, for: indexPath) as? LaunchedRocketsCell
        if let rocket = rockets?[indexPath.item] {
            cell?.configure(name: rocket.rocketName, color: rocket.rocketColor)
            return cell ?? UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
}
extension LaunchedRocketsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let rocketID = self.rockets?[indexPath.item].rocketID else {
            return
        }
        let listVC = MyLaunchedRocketViewController(rocketID: rocketID)
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}

extension LaunchedRocketsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 26
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 48) / 2 - 16
        return CGSize(width: width, height: 188)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 36, left: 24, bottom: 24, right: 24)
        return insets
    }
}
