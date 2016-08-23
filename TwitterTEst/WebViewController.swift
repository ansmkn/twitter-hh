//
//  WebView.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 2/11/15.
//  Copyright (c) 2015 Dongri Jin. All rights reserved.
//

//import OAuthSwift
//
//    import UIKit
//    typealias WebView = UIWebView // WKWebView
//
//class WebViewController: OAuthWebViewController {
//
//    var targetURL : NSURL = NSURL()
//    let webView : WebView = WebView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.webView.frame = UIScreen.mainScreen().bounds
//        self.webView.scalesPageToFit = true
//        self.webView.delegate = self
//        self.view.addSubview(self.webView)
//        loadAddressURL()
//        
//        
//    }
//
//    override func handle(url: NSURL) {
//        targetURL = url
//        super.handle(url)
//        
//        loadAddressURL()
//    }
//
//    func loadAddressURL() {
//        let req = NSURLRequest(URL: targetURL)
//        self.webView.loadRequest(req)
//    }
//}
//extension WebViewController: UIWebViewDelegate {
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if let url = request.URL where (url.scheme == "oauth-swift"){
//            self.dismissWebViewController()
//        }
//        return true
//    }
//}
//
