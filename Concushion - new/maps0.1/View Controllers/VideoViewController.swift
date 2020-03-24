//
//  contactCell.swift
//  maps0.1
//
//  Created by Caleb Foglio on 2/4/20.
//  Copyright © 2020 Prateek Bhatt. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class VideoViewController: UIViewController, WKUIDelegate {
    
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var forwardButton: UIBarButtonItem!
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var progView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
        // Visuals
        toolBar.backgroundColor?.withAlphaComponent(0.5)
        
        // Observer for loading bar
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        progView.setProgress(Float(webView.estimatedProgress), animated: true)
        
    }
 
    @IBAction func backButtonPressed(_ sender: Any) {
        if (webView.canGoBack){
            webView.goBack()
        }
    }
    
    @IBAction func forwardButtonPushed(_ sender: Any) {
        if (webView.canGoForward){
            webView.goForward()
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        
        webView.reload()
    }
    
    // Progress Bar
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (webView.isLoading){
            if webView.estimatedProgress == 1.0 {
                progView.isHidden = true
            }
            else if keyPath == "estimatedProgress" {
                progView.isHidden = false
                progView.progress = Float(webView.estimatedProgress)
            }
        }
        else{
            progView.isHidden = true
        }
        
    }
    
}
