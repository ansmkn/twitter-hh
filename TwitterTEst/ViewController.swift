////
////  ViewController.swift
////  TwitterTEst
////
////  Created by Anton Maksimov on 10.08.16.
////  Copyright © 2016 HeadsAndHands. All rights reserved.
////
//
//import UIKit
//import Foundation
//import Fuzi
//import OAuthSwift
//import JASON
//
//class ViewController: UIViewController {
//    
//    lazy var activityIndicatorView: UIActivityIndicatorView = {
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
//        activityIndicator.hidesWhenStopped = true
//        self.view.addSubview(activityIndicator)
//        activityIndicator.frame = UIScreen.mainScreen().bounds
//        activityIndicator.startAnimating()
//        return activityIndicator
//    }()
//
//    var links: [VideoLink]?
//    var buffer: NSMutableData?
//    var expectedContentLength: Int?
//    var oauthswift: OAuthSwift?
//    let mediaUploadUrl = "https://upload.twitter.com/1.1/media/upload.json"
//    
//    @IBOutlet weak var statusLabel: UILabel!
//    @IBOutlet weak var progressView: UIProgressView!
//    @IBOutlet weak var srcUrlTextView: UITextView!
//    
//    @IBOutlet weak var tweetTextView: UITextView!
//    
//    @IBAction func getLinkButtonTouch(sender: AnyObject) {
//        
//        //pic.twitter.com/TUtyO6Cn6c
//        let myURLString = srcUrlTextView.text
//        let matches = matchesForRegexInText("status\\/.*$", text: myURLString)
//        let twitId = (matches[0] as NSString).substringFromIndex(7)
//        
//        self.authorization(afterDo: {
//            
//            self.activityIndicatorView.startAnimating()
//            self.loadingLinks(twitId, completition: {
//                (result, text) in
//                if let links = result where result?.count != 0 {
//                    self.links  = links
//                    
//                } else {
//                    //trying to get links via html requests
//                    let twitHtml = self.getHTMLByUrl("https://twitter.com/i/videos/tweet/\(twitId)")
//                    let jsonConfig = self.getJsonConfig(twitHtml)
//                    let jsonData = jsonConfig.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//                    
//                    let json_result = self.jsonObjFromData(jsonData!)
//                    if let vmap_url = json_result["vmap_url"] {
//                        let vmapHtmlContent = self.getHTMLByUrl(vmap_url as! String)
//                        self.links = self.getVmapLink(with: vmapHtmlContent)
//                    }
//                    if self.links == nil {
//                        self.showError("somethign went wrong try another tweet")
//                        self.activityIndicatorView.stopAnimating()
//                        return
//                    }
//                }
//                self.activityIndicatorView.stopAnimating()
////                self.tweetTextView.text = text
//                self.performSegueWithIdentifier("toLinks", sender: nil)
//                //
//            })
//        })
//    }
//    
//    func authorization(afterDo completition:() -> Void) {
//        guard self.oauthswift == nil else {
//            completition()
//            print("user already authorized")
//            return
//        }
//        let oauthswift = OAuth1Swift(
//            consumerKey:    consumerKey,
//            consumerSecret: consumerSecret,
//            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
//            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
//            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
//        )
//        self.oauthswift = oauthswift
//        oauthswift.authorizeWithCallbackURL( NSURL(string: "ru.handh.twitest.TwitterTEst://oauth-callback/twitter")!, success: {
//            credential, response, parameters in
//            print("Twitter authorization response: \(parameters)")
//            completition()
//            
//            }, failure: { error in
//                print(error.localizedDescription)
//            }
//        )
//    }
//
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.buffer = NSMutableData()
//        progressView.progress = 0.0
//        self.title = "twittor machine"
//        self.srcUrlTextView.delegate = self
//        self.tweetTextView.delegate = self
//        
//        self.progressView.hidden = true
//                // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func loadingLinks(tweetId: String, completition: ([VideoLink]?, tweetText: String?) -> Void) {
//        let params = [ "id" : tweetId]
//        oauthswift?.client.get("https://api.twitter.com/1.1/statuses/show.json", parameters:params, success: { (data, response) in
//            let json = JSON(data)
//            let text = json["text"].stringValue
//            print(json)
//            guard let variants = json["extended_entities"]["media"][0]["video_info"]["variants"].jsonArray else {
//                completition(nil, tweetText:text)
//                return
//            }
//   
//            let links = variants.map {
//                VideoLink(bitrate: $0["bitrate"].stringValue,
//                    contentType: $0["content_type"].stringValue,
//                    url:$0["url"].stringValue)
//                }.filter {
//                    $0.contentType == "video/mp4"
//            }
//            completition(links, tweetText: text)
//            
//            }, failure: {
//                error in
//                print(error)
//        })
//    }
//    
//    func getVmapLink(with plainXml: String) -> [VideoLink]? {
//        do {
//            let doc = try XMLDocument(string: plainXml, encoding: NSUTF8StringEncoding)
//            guard let variants = doc.firstChild(xpath: "//vmap:VMAP/vmap:Extensions/vmap:Extension/tw:amplify/tw:content/tw:videoVariants") else {
//                print("can't parsed an xml doc")
//                return nil
//            }
//            
//            var links = [VideoLink]()
//            for variant in variants.children {
//                
//                if let fullUrl = variant.attr("url"),
//                    let contentType = variant.attr("content_type"),
//                    let bitRate = variant.attr("bit_rate") {
//                    
//                    let url = NSURL(string: fullUrl)!
//                    let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
//                    components?.query = nil
//                    
//                    links.append(VideoLink(bitrate: bitRate, contentType: contentType, url: components!.string!))
//                }
//            }
////            return variant!["url"]!
//            return links.filter {
//                $0.contentType == "video/mp4"
//            }
//        } catch let error {
//            print(error)
//            return nil
//        }
//    }
//    
//    func getJsonConfig(html: String) -> String {
//        do {
//            let doc = try HTMLDocument(string: html, encoding: NSUTF8StringEncoding)
//    
//            for div in doc.css("#playerContainer") {
//                return div["data-config"]!
//            }
//            return ""
//        } catch let error {
//            print(error)
//            return ""
//        }
//    }
//    
//    func jsonObjFromData(jsonData: NSData) -> NSDictionary {
//        let result = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
//        return (result as? NSDictionary) ?? [:]
//    }
//
//    func getHTMLByUrl(url: String) -> String {
//        guard let myURL = NSURL(string: url) else {
//            print("Error: \(url) doesn't seem to be a valid URL")
//            return ""
//        }
//        
//        do {
//            let myHTMLString = try String(contentsOfURL: myURL)
//            return myHTMLString
//        } catch let error as NSError {
//            print("Error: \(error)")
//            return ""
//        }
//    }
//////    https://api.twitter.com/1.1/statuses/show/763282185252134912
////    
//    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
//        
//        do {
//            let regex = try NSRegularExpression(pattern: regex, options: [])
//            let nsString = text as NSString
//            let results = regex.matchesInString(text,
//                                                options: [], range: NSMakeRange(0, nsString.length))
//            return results.map { nsString.substringWithRange($0.range)}
//        } catch let error as NSError {
//            print("invalid regex: \(error.localizedDescription)")
//            return []
//        }
//    }
//    
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "toLinks" {
//            let vc = segue.destinationViewController as! LinksViewController
//            vc.delegate = self
//            vc.links = links
//        }
//    }
//    
//    
//    func showError(string: String?) {
//        let message = string ?? "Unknown error"
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
//    func performInitComand(videoData: NSData, completition: (String) -> Void) {
//        let message = ["command" : "INIT", "media_type" : "video/mp4.", "total_bytes" : String(videoData.length)]
//        oauthswift?.client.post(mediaUploadUrl, parameters: message, headers: nil, success: {
//            (data, response) in
//            let jsonDict = JSON(data)
//            let media_id = jsonDict["media_id_string"].stringValue
//            completition(media_id)
//            }, failure: { error in
//        })
//    }
//    
//    func performAppendCommand(videoData: NSData, chunkId: Int, media_id: String, completition: () -> Void) {
//        let mb = 1048576
//        let lengh = videoData.length
//        let alreadyUploaded = mb * chunkId
//        let chunkLength = alreadyUploaded + mb < lengh ? mb : lengh - alreadyUploaded
//        
//        let numOfChunks = lengh/mb + 1
//        guard chunkId < numOfChunks else {
//            completition()
//            return
//        }
//        self.progressView.progress = Float(chunkId + 1)/Float(numOfChunks)
//        
//        let range = NSMakeRange(alreadyUploaded, chunkLength)
//        print("Prepare do upload chunk with range: \(range)")
//        let chunk = videoData.subdataWithRange(range)
//        
//        let appendUrl = "https://upload.twitter.com/1.1/media/upload.json?command=APPEND&media_id=\(media_id)&segment_index=\(chunkId)"
//        let mData = OAuthSwiftMultipartData(name: "media", data: chunk, fileName: nil, mimeType: nil)
//        
//        oauthswift?.client.postMultiPartRequest(appendUrl, method: OAuthSwiftHTTPRequest.Method.POST, parameters: [:], multiparts: [mData],
//                                                success: {
//                                                (data, response) in
//                                                self.performAppendCommand(videoData, chunkId: chunkId + 1, media_id: media_id, completition: completition)
//            }, failure: { (error) in
//                print("error after append: \(error)")
//        })
//    }
//    
//    func performFinalizeCommand(media_id: String, completition: () -> Void) {
//        
//        let finalizeMessage = ["command":"FINALIZE", "media_id": media_id]
//        oauthswift?.client.post(mediaUploadUrl, parameters: finalizeMessage, headers: nil, success:  {
//                (data, response) in
//                completition()
//            }, failure: {
//                error in
//                self.showError(error.localizedDescription)
//        })
//    }
//    
//    func performUpdateStatus(media_id: String, completition: () -> Void) {
//        let url = "https://api.twitter.com/1.1/statuses/update.json"
//        let defaultTweet = "Tweet at:\(NSDate())"
//        let statusParams = ["status": tweetTextView.text.isEmpty ? defaultTweet : tweetTextView.text, "wrap_links": "true", "media_ids": media_id]
//        oauthswift?.client.post(url, parameters: statusParams, headers: nil, success: {
//            (data, response) in
//            completition()
//            }, failure: {
//                error in
//                let errorMessageJson = JSON(error.userInfo["Response-Body"])
//                self.showError(errorMessageJson.stringValue)
//                self.statusLabel.text = "Failure on the statuses/update step"
//                print(error)
//        })
//    }
//    
//    func uploadingVideo(videoData: NSData) {
//        
//        self.statusLabel.text = "Uploading video"
//        self.performInitComand(videoData) { (media_id) in
//            self.statusLabel.text = "Uploading video"
//            self.performAppendCommand(videoData, chunkId: 0, media_id: media_id, completition: {
//                self.statusLabel.text = "Finalizing video upload"
//                
//                self.performFinalizeCommand(media_id, completition: {
//                    self.progressView.progress = 1.0
//                    self.statusLabel.text = "Updating user status"
//                    self.performUpdateStatus(media_id, completition: {
//                        self.statusLabel.text = "Video was sending"
//                        self.progressView.progress = 0.0
//                        self.progressView.hidden = true
//                    })
//                })
//            })
//        }
//
//    }
//    
//}
//
//extension ViewController: LinksViewControllerDelegate {
//    func didSelect(link: VideoLink) {
//        let url = NSURL(string: link.url)!
//        print("selected video url:\(url)")
//        self.statusLabel.text = "Downloading video"
//        
//        self.progressView.hidden = false
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
//        let task = session.dataTaskWithRequest(NSURLRequest(URL: url))
//        print ("did begin load data")
//        task.resume()
//    }
//    
//}
//
//extension ViewController: NSURLSessionTaskDelegate {
//    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
//        let contentLength = Int(response.expectedContentLength)
//        guard contentLength != 0 else {
//            dataTask.cancel()
//            dispatch_async(dispatch_get_main_queue()) {
//                self.statusLabel.text = "Error. Try again."
//                self.showError("Unable to download")
//            }
//            return
//        }
//        //here you can get full lenth of your content
//        expectedContentLength = Int(response.expectedContentLength)
//        print("video file size:\(expectedContentLength)")
//        completionHandler(NSURLSessionResponseDisposition.Allow)
//    }
//    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
//        
//        buffer?.appendData(data)
//        dispatch_async(dispatch_get_main_queue()) {
//            
//            self.progressView.progress = Float(self.buffer!.length) / Float(self.expectedContentLength!)
//        }
////
//    }
//    
//    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            
//            self.progressView.progress = 1.0   // download 100% complete
//            self.uploadingVideo(self.buffer!)
//            self.buffer = NSMutableData()
//        }
//        
//    }
//    
//}
//
//extension ViewController: UITextViewDelegate {
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
//    
//}
//
//
//
