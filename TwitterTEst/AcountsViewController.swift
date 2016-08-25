//
//  AcountsViewController.swift
//  TwitterTEst
//
//  Created by Sea on 25/08/16.
//  Copyright © 2016 HeadsAndHands. All rights reserved.
//

import UIKit
import Accounts
import SwifteriOS

protocol AccountsViewControllerDelegate {
    func didSelect(account: ACAccount)
}

class AcountsViewController: UIViewController {
    var delegate: AccountsViewControllerDelegate?
    var accounts: [ACAccount]?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AcountsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (accounts?.count) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingHead
        let ac = accounts![indexPath.row]
        cell.textLabel?.text = ac.username
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.didSelect(accounts![indexPath.row])
    }
}
