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

class StartViewController: UIViewController {

    let useACAccount = true
    var swifter: Swifter?
    
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
                let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                if twitterAccounts?.count == 0 {
                    self.alertWithTitle("Error", message: "There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
                } else {
                    let twitterAccount = twitterAccounts[0] as! ACAccount
                    
                    self.swifter = Swifter(account: twitterAccount)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("TO_MAIN", sender: nil)
                    }
                }
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! MainViewController
        vc.swifter = self.swifter
    }
    
//    @IBAction func didTouchUpInsideLoginButton(sender: AnyObject) {
//        let failureHandler: ((NSError) -> Void) = { error in
//            
//            self.alertWithTitle("Error", message: error.localizedDescription)
//        }
//        
//        if useACAccount {
//            let accountStore = ACAccountStore()
//            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
//            
//            // Prompt the user for permission to their twitter account stored in the phone's settings
//            accountStore.requestAccessToAccountsWithType(accountType, options: nil) { granted, error in
//                
//                if granted {
//                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)
//                    if twitterAccounts?.count == 0 {
//                        self.alertWithTitle("Error", message: "There are no Twitter accounts configured. You can add or create a Twitter account in Settings.")
//                    } else {
//                        let twitterAccount = twitterAccounts[0] as! ACAccount
//                        self.swifter = Swifter(account: twitterAccount)
//                        self.fetchTwitterHomeStream()
//                    }
//                } else {
//                    self.alertWithTitle("Error", message: error.localizedDescription)
//                }
//            }
//        } else {
//            let url = NSURL(string: "swifter://success")!
//            swifter.authorizeWithCallbackURL(url, presentFromViewController: self, success: { _ in
//                self.fetchTwitterHomeStream()
//                }, failure: failureHandler)
//        }
//    }
//    
    func fetchTwitterHomeStream() {
        let failureHandler: ((NSError) -> Void) = { error in
            self.alertWithTitle("Error", message: error.localizedDescription)
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
