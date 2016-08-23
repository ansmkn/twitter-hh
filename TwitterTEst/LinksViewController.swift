//
//  LinksViewController.swift
//  TwitterTEst
//
//  Created by Head HandH on 18/08/16.
//  Copyright © 2016 HeadsAndHands. All rights reserved.
//

import UIKit

protocol LinksViewControllerDelegate {
    func didSelect(link: VideoLink)
}

class LinksViewController: UIViewController {
    var delegate: LinksViewControllerDelegate?
    var links: [VideoLink]?
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LinksViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (links?.count) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingHead
        let link = links![indexPath.row]
        cell.textLabel?.text = link.url
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.navigationController?.popViewControllerAnimated(true)
        self.delegate?.didSelect(links![indexPath.row])
    }
}