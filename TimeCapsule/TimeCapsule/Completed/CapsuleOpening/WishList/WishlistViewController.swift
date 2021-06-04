//
//  WishlistViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/03/12.
//

import UIKit

class WishlistViewController: UIViewController {
    
    let dataManager = WishlistDataManager()
    let wishCell = WishlistCell()
    //var wishes = ["유럽여행", "워터파크", "콘서트", "디즈니랜드", "미국도 갈거야"]
    var marbleList = [MarbleList]()
    var marbleColorCount = [MarbleColorCount]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var purpleView: UIView!
    
    @IBOutlet weak var redCircle: UIView!
    @IBOutlet weak var yellowCircle: UIView!
    @IBOutlet weak var greenCircle: UIView!
    @IBOutlet weak var blueCircle: UIView!
    @IBOutlet weak var purpleCircle: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var purpleLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.getMarbles(viewController: self)
        
        self.view.backgroundColor = #colorLiteral(red: 0.4529297948, green: 0.2904702425, blue: 1, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WishlistCell", bundle: nil), forCellReuseIdentifier: wishCell.cellID)
        tableView.rowHeight = 80
        tableView.backgroundColor = #colorLiteral(red: 0.4529297948, green: 0.2904702425, blue: 1, alpha: 1)
        
        redView.layer.cornerRadius = 8
        redView.layer.borderColor = UIColor.black.cgColor
        redView.layer.borderWidth = 3
        yellowView.layer.cornerRadius = 8
        yellowView.layer.borderColor = UIColor.black.cgColor
        yellowView.layer.borderWidth = 3
        greenView.layer.cornerRadius = 8
        greenView.layer.borderColor = UIColor.black.cgColor
        greenView.layer.borderWidth = 3
        blueView.layer.cornerRadius = 8
        blueView.layer.borderColor = UIColor.black.cgColor
        blueView.layer.borderWidth = 3
        purpleView.layer.cornerRadius = 8
        purpleView.layer.borderColor = UIColor.black.cgColor
        purpleView.layer.borderWidth = 3
        
        redCircle.layer.cornerRadius = redCircle.frame.size.width/2
        yellowCircle.layer.cornerRadius = redCircle.frame.size.width/2
        greenCircle.layer.cornerRadius = redCircle.frame.size.width/2
        blueCircle.layer.cornerRadius = redCircle.frame.size.width/2
        purpleCircle.layer.cornerRadius = redCircle.frame.size.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorView.setNeedsDisplay()
        //tableView.reloadData()
    }
    
    
    func didSuccessMarbleList() {
        tableView.reloadData()
        redLabel.text = String(marbleColorCount[0].marbleCount)
        yellowLabel.text = String(marbleColorCount[1].marbleCount)
        greenLabel.text = String(marbleColorCount[2].marbleCount)
        blueLabel.text = String(marbleColorCount[3].marbleCount)
        purpleLabel.text = String(marbleColorCount[4].marbleCount)
        viewWillAppear(true)
    }

}

extension WishlistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marbleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: wishCell.cellID) as! WishlistCell
        //cell.wishLabel.text = wishes[indexPath.row]
        let wish = marbleList[indexPath.row]
        cell.wishLabel.text = wish.content
        cell.dateLabel.text = wish.createdAt
        switch wish.marbleColor {
        case 0:
            cell.stoneImageView.image = UIImage(named: "small_dol_1")
        case 1:
            cell.stoneImageView.image = UIImage(named: "small_dol_2")
        case 2:
            cell.stoneImageView.image = UIImage(named: "small_dol_3")
        case 3:
            cell.stoneImageView.image = UIImage(named: "small_dol_4")
        case 4:
            cell.stoneImageView.image = UIImage(named: "small_dol_5")
        default:
            cell.stoneImageView.image = UIImage(named: "small_dol_1")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row number \(indexPath.row) selected")
    }
}
