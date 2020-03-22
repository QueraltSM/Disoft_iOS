//
//  HomeVC.swift
//  Disoft
//
//  Created by Queralt Sosa Mompel on 26/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import UIKit
import WebKit

var menu_vc : MenuVC!
var myWebView: WKWebView!
var password: String = ""
var nickname: String = ""
var username: String = ""
var token: String = ""

class HomeVC: UIViewController {
    
    var popupWebView: WKWebView?
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webViewView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password = UserDefaults.standard.object(forKey: "password") as! String
        nickname = UserDefaults.standard.object(forKey: "nickname") as! String
        username = UserDefaults.standard.object(forKey: "username") as! String
        token = UserDefaults.standard.object(forKey: "token") as! String
        self.progressView.tintColor = UIColor(hexString: "#8B0000")
        self.progressView.transform = CGAffineTransform(scaleX: 1,y: 2)
        setMenu()
        setupWebView()
        openIndex(url: "https://admin.dicloud.es/noticias/index.asp")
    }
    
    func openIndex(url: String) {
        let url = url + "?company=" + nickname
            + "&user=" + username + "&pass=" + password + "&token=" + token + "&l=1"
        loadWebView(urlPath: url)
    }
    
    func startProgressView() {
        self.progressView.alpha = 1.0
        progressView.setProgress(Float(myWebView.estimatedProgress), animated: true)
        if (myWebView.estimatedProgress >= 1.0) {
            UIView.animate(withDuration: 0.3, delay: 0.1, options:
                UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
                    self.progressView.alpha = 0.0
            }, completion: { (finished:Bool) -> Void in
                self.progressView.progress = 0
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if myWebView.isLoading {
                startProgressView()
            } else {
                self.progressView.layer.sublayers?.forEach { $0.removeAllAnimations() }
            }
        }
    }
    
    @IBAction func refreshWebView(_ sender: Any) {
        loadWebView(urlPath: (myWebView.url?.absoluteString)!)
    }

    func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        myWebView = WKWebView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        myWebView = WKWebView(frame: view.bounds, configuration: configuration)
        myWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        myWebView.uiDelegate = self
        myWebView.navigationDelegate = self
        webViewView.addSubview(myWebView)
    }
    
    func loadWebView(urlPath: String) {
        myWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        if let url = URL(string: urlPath) {
            let urlRequest = URLRequest(url: url)
            myWebView.load(urlRequest)
        }
    }
    
    func openMenu() {
        self.addChild(menu_vc)
        self.view.addSubview(menu_vc.view)
        showMenu()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        if AppDelegate.menu_bool {
            openMenu()
        } else {
            closeMenu()
        }
    }
    
    @objc func respondToGesture(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            showMenu()
        case UISwipeGestureRecognizer.Direction.left:
            close_on_swipe()
        default:
            break
        }
    }
    
    func setMenu() {
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:#selector(self.respondToGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
}

func showMenu() {
    AppDelegate.menu_bool = false
    menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
}

func closeMenu() {
    AppDelegate.menu_bool = true
    menu_vc.closeMenu()
}

func close_on_swipe() {
    if AppDelegate.menu_bool {
        showMenu()
    } else {
        closeMenu()
    }
}

extension HomeVC: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        myWebView.addSubview(popupWebView!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }
}

extension HomeVC: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
