//
//  OpenSourceViewController.swift
//  TimeCapsule
//
//  Created by 정지현 on 2021/06/11.
//

import UIKit

class OpenSourceViewController: UIViewController {
    
    let sources = OpenSources.licenses

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "오픈소스"
        view.backgroundColor = .mainPurple
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: OpenSourceTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OpenSourceTableViewCell.identifier)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .mainPurple
    }

}
extension OpenSourceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OpenSourceTableViewCell.identifier) as? OpenSourceTableViewCell
        let source = sources[indexPath.row]
        cell?.configure(text: source.title)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let source = sources[indexPath.row]
        let vc = OpenSourceDetailViewController(titleString: source.title, text: source.text)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
