//
//  AddWishViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import UIKit
import Alamofire

class AddWishViewController: UIViewController{
    
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var wishTextView: UITextView!
    @IBOutlet weak var completionButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tagBaseCircleView: UIView!
    @IBOutlet weak var tagBaseView: UIView!
    
    @IBOutlet weak var openImageView: UIImageView!
    
    @IBOutlet weak var centerY: NSLayoutConstraint!
    var delegate: ReloadDelegate?
    var tagID: Int = 0
    var count: Int = 0
    lazy var tagView = UIView(frame: CGRect(x: tagButton.frame.origin.x, y: tagButton.frame.origin.y, width: 61, height: 128))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wishTextView.delegate = self
        setupUI()
     prepareKeyboard()
    }
    
    func prepareKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        print(#function)
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification{
            centerY.constant = -keyboardFrame.height / 3
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            centerY.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func tagButtonTapped(_ sender: Any) {
        showTagCollection()
    }
    
    @IBAction func completionButtonTapped(_ sender: Any) {
        
        //서버로 데이터 전송
        guard let content = wishTextView.text else { return }
        addMarbles(content: content, index: tagID)
        //dismiss
//        delegate?.reloadView()
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        wishTextView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textCountLabel.text = "\(count+1) / 21"
        containerView.layer.cornerRadius = 30
        containerView.borderWidth = 5
        containerView.borderColor = .black
        
        completionButton.layer.cornerRadius = 8
        completionButton.backgroundColor = UIColor.mainBlack
        completionButton.setTitle("완료", for: .normal)
        completionButton.setTitleColor(.white, for: .normal)
        completionButton.setTitleColor(.white, for: .selected)
        
        wishTextView.layer.cornerRadius = 9
        wishTextView.backgroundColor = UIColor.mainGrey
        tagBaseView.layer.cornerRadius = 7
        tagBaseView.borderWidth = 3
        tagBaseView.borderColor = .black
        tagBaseView.backgroundColor = UIColor.mainGrey
        tagBaseCircleView.layer.cornerRadius = 9
        tagBaseCircleView.borderWidth = 3
        tagBaseCircleView.borderColor = .black
    }
    

    func showTagCollection() {
        
        self.containerView.addSubview(tagView)
        
        let tagWidth = tagButton.frame.width
        let tagCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0)
            layout.itemSize = CGSize(width: tagWidth, height: 24)
            layout.estimatedItemSize = CGSize(width: tagWidth, height: 24)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: tagWidth, height: 128), collectionViewLayout: layout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundColor = UIColor.init(hex: 0xEFEFEF)
            
            return collectionView
        }()
        
        let nib1 = UINib(nibName: TagCollectionViewCell.identifier, bundle: nil)
        tagCollectionView.register(nib1, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        tagCollectionView.borderWidth = 3
        tagCollectionView.borderColor = .black
        tagCollectionView.layer.cornerRadius = 7
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        tagView.addSubview(tagCollectionView)
        
        let imageView: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "icon_open")
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        tagView.addSubview(imageView)
        imageView.trailingAnchor.constraint(equalTo: tagView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: tagView.topAnchor, constant: 0.5).isActive = true
    }
    
    func addMarbles(content: String, index: Int) {
        let headers: HTTPHeaders = ["X-ACCESS-TOKEN": Constant.testToken]
        let params = ["content": content,
                      "marbleColor": "\(index)"]
        
        let url = URLType.addMarble.makeURL
        AF.request(url, method: .post, parameters: params, encoder: JSONParameterEncoder.default, headers: headers)
            .response { [weak self] response in
                print(response)
                guard let self = self else { return }
                self.delegate?.reloadView()
                self.dismiss(animated: true, completion: nil)
            }
            
    }
}

extension AddWishViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
        
        cell.colorView.backgroundColor = mainColorSet[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt")
        tagID = indexPath.item
        tagBaseCircleView.backgroundColor = mainColorSet[tagID]
        self.tagView.removeFromSuperview()
    }
}

extension AddWishViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textCount.text = "(\(min(updatedText.count,21))/21)"
        return updatedText.count <= 21
    }
}
