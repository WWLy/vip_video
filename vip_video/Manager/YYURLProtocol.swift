//
//  YYURLProtocol.swift
//  vip_video
//
//  Created by WWLy on 2019/12/17.
//  Copyright © 2019 YY. All rights reserved.
//

import UIKit

class YYURLProtocol: URLProtocol, URLSessionDataDelegate, URLSessionTaskDelegate {
    /// URLSession数据请求任务
    var dataTask: URLSessionDataTask?
    /// url请求响应
    var urlResponse: URLResponse?
    /// url请求获取到的数据
    var receivedData: NSMutableData?
 
    /// 判断这个 protocol 是否可以处理传入的 request
    override class func canInit(with request: URLRequest) -> Bool {
        // 对于已处理过的请求则跳过，避免无限循环标签问题
        if URLProtocol.property(forKey: "WKURLProtocolHandledKey", in: request) != nil {
            return false
        }
        return true
    }
 
    /// 回规范化的请求（通常只要返回原来的请求就可以）
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        print("=====", request)
        guard let m_url = request.mainDocumentURL else {
            return request
        }
 
        if m_url.absoluteString.contains("XXX"){
            var mrequest  = request
            mrequest.setValue("aaaa", forHTTPHeaderField: "ssdf")
            return mrequest
        }
 
        return request
    }
 
    /// 判断两个请求是否为同一个请求，如果为同一个请求那么就会使用缓存数据。
    /// 通常都是调用父类的该方法。我们也不许要特殊处理。
    override class func requestIsCacheEquivalent(_ aRequest: URLRequest,
                                                 to bRequest: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, to:bRequest)
    }
 
    /// 开始处理这个请求
    override func startLoading() {
 
        let newRequest = (self.request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        // NSURLProtocol 接口的 setProperty() 方法可以给URL请求添加自定义属性。
        //（这样把处理过的请求做个标记，下一次就不再处理了，避免无限循环请求）
        URLProtocol.setProperty(true, forKey: "WKURLProtocolHandledKey",
                                in: newRequest)
 
        // 使用 URLSession 从网络获取数据
        let defaultConfigObj = URLSessionConfiguration.default
        let defaultSession = Foundation.URLSession(configuration: defaultConfigObj,
                                                   delegate: self, delegateQueue: nil)
        self.dataTask = defaultSession.dataTask(with: self.request)
        self.dataTask!.resume()
    }
 
    /// 结束处理这个请求
    override func stopLoading() {
        self.dataTask?.cancel()
        self.dataTask       = nil
        self.receivedData   = nil
        self.urlResponse    = nil
    }
 
    /// URLSessionDataDelegate 相关的代理方法
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        print("======", response)
        self.client?.urlProtocol(self, didReceive: response,
                                 cacheStoragePolicy: .notAllowed)
        self.urlResponse = response
        self.receivedData = NSMutableData()
        completionHandler(.allow)
    }
 
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
        self.receivedData?.append(data)
    }
 
    /// URLSessionTaskDelegate 相关的代理方法
    func urlSession(_ session: URLSession, task: URLSessionTask
        , didCompleteWithError error: Error?) {
        if error != nil {
            self.client?.urlProtocol(self, didFailWithError: error!)
        } else {
            // 保存获取到的请求响应数据
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
}
