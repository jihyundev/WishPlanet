//
//  CompletedRocketsViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/20.
//

import UIKit

class CompletedRocketsViewController: UIViewController {
    
    private let cellIdentifier = "RocketCollectionViewCell"
    private var rockets: [GetRocketsResponse]? = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RocketCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func didRetrieveData() {
        
    }
    
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }
}
// MARK: - UICollectionViewDataSource
extension CompletedRocketsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        //return rockets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension CompletedRocketsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("LOG - current index: \(indexPath.item)")
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
