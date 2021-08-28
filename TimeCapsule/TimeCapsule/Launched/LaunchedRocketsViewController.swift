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
        setNavBar()
    }
    
    private func setupUI() {
        collectionView.backgroundColor = .clear
        view.backgroundColor = .popupViolet
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -30), for: .default)
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
    
    func didRetrieveData(rockets: [GetRocketsResponse]) {
        print("CompletedRocketsViewController - didRetrieveData() called")
        self.rockets = rockets
        collectionView.reloadData()
        //self.presentCenterAlert(message: "누르면 내역을 볼 수 있어요!")
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
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 2
        return CGSize(width: width, height: width)
    }
}
