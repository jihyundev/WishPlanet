//
//  OpenSourceDetailViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/07/10.
//

import UIKit

class OpenSourceDetailViewController: UIViewController {
    
    private let titleString: String
    private let text: String
    
    init(titleString: String, text: String) {
        self.titleString = titleString
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        textLabel.text = text
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .white
    }

}
