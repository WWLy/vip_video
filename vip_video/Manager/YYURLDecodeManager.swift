//
//  YYURLDecodeManager.swift
//  vip_video
//
//  Created by WWLy on 2019/12/16.
//  Copyright © 2019 YY. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class YYURLDecodeManager: NSObject {
    
    static let sharedInstance = YYURLDecodeManager()
    
//    let host: URL = URL(string: "https://www.nxflv.com/apz.php")!
    let host: String = "http://okjx.cc/?url="
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.frame = SCREEN_BOUNDS
        webView.navigationDelegate = self
        UIApplication.shared.windows.last?.addSubview(webView)
        return webView
    }()
    
    
    func decodeURLInWebView(urlString: String, complete: (_: String) -> Void) {
        let newURLString = host.appending(urlString)
        complete(newURLString)
//        guard let url = URL(string: newURLString) else {
//            return;
//        }
//        let request = URLRequest(url: url)
//        self.webView.load(request)
    }
    
    func decodeURL(urlString: String) {
//        let refer = "http://okjx.cc/?url=".appending(host.absoluteString).toBase64()
//        let time = String(format: "%ld", Int(NSDate().timeIntervalSince1970))
//        let ref = "1"
//        let ios = "1"
//        let param = ["url": urlString, "refer": refer, "ref": ref, "ios": ios, time: time, "other": urlString.toBase64()]
//        AF.request(host, method: .post, parameters: param, encoder: URLEncodedFormParameterEncoder.default, headers: nil, interceptor: nil).responseJSON { (response) in
//            print(response.value)
//            print(response.result)
//        }
    }
}

/// WKNavigationDelegate
extension YYURLDecodeManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = "document.body.innerText"
        webView.evaluateJavaScript(js) { (res, error) in
            print(res, error)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let js = "document.body.innerText"
        webView.evaluateJavaScript(js) { (res, error) in
            print(res, error)
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let js = "document.body.innerText"
        webView.evaluateJavaScript(js) { (res, error) in
            print(res, error)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let js = "document.body.innerText"
        webView.evaluateJavaScript(js) { (res, error) in
            print(res, error)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        let js = "document.body.innerText"
        webView.evaluateJavaScript(js) { (res, error) in
            print(res, error)
        }
    }
}

extension String {
    // base64编码
    func toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    // base64解码
    func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
