//
//  StartViewController.swift
//  TwitterTEst
//
//  Created by Head HandH on 23/08/16.
//  Copyright © 2016 HeadsAndHands. All rights reserved.
//

import UIKit
import Accounts
import Social
import SwifteriOS
import SafariServices

let accountsVCIdentifier = "ACCOUNTS"
let mainVCIdentifier = "TO_MAIN"

class StartViewController: UIViewController {

    let useACAccount = true
    var swifter: Swifter?
    var twitterAccounts: [ACAccount]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tapLoginButton(sender: AnyObject) {
        
        let failureHandler: ((NSError) -> Void) = { error in
            self.alertWithTitle("Error", message: error.localizedDescription)
        }
        
        if useACAccount {
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            
            // Prompt the user for permission to their twitter account stored in the phone's settings
            accountStore.requestAccessToAccountsWithType(accountType, options: nil) { granted, error in
                
                dispatch_async(dispatch_get_main_queue()) {
                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                    if twitterAccounts?.count == 0 {
                        self.alertWithTitle("Error", message: "There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                    } else {
                        self.twitterAccounts = twitterAccounts as? [ACAccount]
                        if (twitterAccounts.count == 1) {
                            self.didSelect(twitterAccounts[0] as! ACAccount)
                        } else {
                            self.performSegueWithIdentifier(accountsVCIdentifier, sender: twitterAccounts)
                        }
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == accountsVCIdentifier {
            let vc = segue.destinationViewController as! AcountsViewController
            vc.accounts = self.twitterAccounts
            vc.delegate = self
        } else {
            let vc = segue.destinationViewController as! MainViewController
            vc.swifter = self.swifter
        }
    }
    
    func alertWithTitle(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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

extension StartViewController: AccountsViewControllerDelegate {
    func didSelect(account: ACAccount) {
        self.swifter = Swifter(account: account)
        self.performSegueWithIdentifier(mainVCIdentifier, sender: nil)
    }
}
