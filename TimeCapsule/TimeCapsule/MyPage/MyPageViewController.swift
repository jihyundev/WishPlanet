//
//  MyPageViewController.swift
//  TimeCapsule
//
//  Created by Beomcheol Kwon on 2021/03/12.
//

import UIKit

class MyPageViewController: UIViewController {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var notiSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func editProfileButtonTapped(_ sender: Any) {
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
    
    @IBAction func licenseButtonTapped(_ sender: Any) {
    }
    
    @IBAction func wishPlanetButtonTapped(_ sender: Any) {
    }
    
    func updateUI() {
        
    }
}
