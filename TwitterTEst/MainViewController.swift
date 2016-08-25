//
//  MainViewController.swift
//  TwitterTEst
//
//  Created by Head HandH on 22/08/16.
//  Copyright © 2016 HeadsAndHands. All rights reserved.
//

import UIKit
import JASON
import Social
import SwifteriOS

class MainViewController: UIViewController {
    var swifter: Swifter?
    
    // Default to using the iOS account framework for handling twitter auth
    let useACAccount = true
//
    @IBOutlet weak var srcUrlTextView: UITextView!
    @IBOutlet weak var tweetTextView: UITextView!
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = UIScreen.mainScreen().bounds
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Twitter example"
        self.srcUrlTextView.delegate = self
        
    }
    
    @IBAction func getLinkButtonTouch(sender: AnyObject) {
        let failureHandler: ((NSError) -> Void) = { error in
            
            self.showError(error.localizedDescription)
        }
        
        let myURLString = srcUrlTextView.text
        let matches = matchesForRegexInText("status\\/.*$", text: myURLString)
        let tweetId = (matches[0] as NSString).substringFromIndex(7)
        self.activityIndicatorView.startAnimating()
        self.swifter?.getStatusesShowWithID(tweetId, count: nil, trimUser: nil, includeMyRetweet: nil, includeEntities: nil, success: {
            (status) in
            guard status != nil else {
                self.showError("Can not download tweet")
                return
            }
            if let text = status?["text"]?.string {
                
                self.activityIndicatorView.stopAnimating()
                self.update(text)
//                
//                self.swifter?.postStatusUpdate(text, inReplyToStatusID: nil, lat: nil, long: nil, placeID: nil, displayCoordinates: nil, trimUser: nil, media_ids: [], success: { (astatus) in
//                    guard astatus != nil else {
//
//                        return
//                    }
//                    
//                    }, failure: failureHandler)
                print(text)
            }
        }, failure: failureHandler)
        
        
    }
    
    func update(status: String) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let composer = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            composer.setInitialText(status)
            composer.completionHandler = {
                result in
                if case SLComposeViewControllerResult.Done = result {
                    
                    self.showMessage("Operation was successfully completed")
                    self.activityIndicatorView.stopAnimating()
                } else {
                    self.showError("Updating was canceled")
                }
            };
            self.presentViewController(composer, animated: true, completion: {
                //
            })
        }
    }
    
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func showError(string: String) {
        dispatch_async(dispatch_get_main_queue()) {
            
            let message = string ?? "Unknown error"
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func showMessage(string: String) {
        dispatch_async(dispatch_get_main_queue()) {
            
            let message = string ?? "Unknown error"
            let alert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

extension MainViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
