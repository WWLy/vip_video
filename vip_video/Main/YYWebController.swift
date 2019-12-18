//
//  YYWebController.swift
//  vip_video
//
//  Created by WWLy on 2019/12/16.
//  Copyright © 2019 YY. All rights reserved.
//

import UIKit
import WebKit

class YYWebController: UIViewController {
    
    var currentURLString: String?
    
    var currentVideoURLString: String?
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("播放", for: .normal)
        if #available(iOS 13.0, *) {
            button.setTitleColor(UIColor(dynamicProvider: { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
                    return CYColor(r: 255, g: 255, b: 255)
                } else {
                    return CYColor(r: 15, g: 76, b: 129)
                }
            }), for: .normal)
        } else {
            button.setTitleColor(CYColor(r: 15, g: 76, b: 129), for: .normal)
        }
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: button), animated: true)
        return button
    }()

    var webView: WKWebView = WKWebView()
    
    lazy var progessView: UIProgressView = {
        let view = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.webView.frame.width, height: 2))
        view.tintColor = CYColor(r: 239, g: 192, b: 80)
        view.trackTintColor = self.webView.backgroundColor
        self.webView.addSubview(view)
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNav()
        
//        URLProtocol.registerClass(YYURLProtocol.self)

        self.initWebView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
//        self.webView.supportURLProtocol()
    }
    
    func initNav() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage.init(named: "back"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.contentEdgeInsets = UIEdgeInsets.init(top: 12, left: 0, bottom: 12, right: 44)
        backButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        self.navigationItem.setLeftBarButton(UIBarButtonItem.init(customView: backButton), animated: true)
    }
    
    func initWebView() {
        self.webView.frame = CGRect(x: 0, y: CYSafeAreaTopHeight, width: self.view.frame.width, height: self.view.frame.height - CYSafeAreaTopHeight)
        self.view.addSubview(self.webView)
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        self.webView.backgroundColor = UIColor.white
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    public func loadURL(urlString: String) {
        guard let url = URL(string: urlString) else {
            return;
        }
        self.currentURLString = urlString
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
    
    public func showPlayButton(isShow: Bool) {
        self.playButton.isHidden = !isShow
    }
    
    @objc func backButtonClick() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 播放
    @objc func playButtonClick() {
        // 获取当前视频的 url
        if self.currentVideoURLString != nil {
            YYURLDecodeManager.sharedInstance.decodeURLInWebView(urlString: self.currentVideoURLString!) { (newURLString) in
                self.loadURL(urlString: newURLString)
            }
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}


extension YYWebController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let webview = object as? WKWebView else {
            return
        }
        if webview == self.webView {
            if keyPath?.elementsEqual("estimatedProgress") ?? false {
                
                let newprogress = Float(truncating: (change?[NSKeyValueChangeKey.newKey] as! NSNumber))
                if newprogress == 1 {
                    self.progessView.isHidden = true
                    self.progessView.setProgress(0, animated: true)
                } else {
                    self.progessView.isHidden = false
                    self.progessView.setProgress(newprogress, animated: true)
                }
            }
        }
    }
}

extension YYWebController: UIGestureRecognizerDelegate {
    
}

extension YYWebController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let urlString = navigationAction.request.url?.absoluteString else {
            return
        }
        if (urlString.contains("v.qq.com")) {
            if (urlString.contains("/cover/")) {
                print("----", urlString)
                self.currentVideoURLString = urlString;
            }
        }
        
        decisionHandler(.allow)
    }
}

extension WKWebView {
    func supportURLProtocol() {
        let selector =  Selector(("registerSchemeForCustomProtocol:"))
         
        let vc = WKWebView().value(forKey: "browsingContextController") as AnyObject
 
        let cls  = type(of: vc) as AnyObject
 
        _ = cls.perform(selector, with: "http")
        _ = cls.perform(selector, with: "https")
    }
}
