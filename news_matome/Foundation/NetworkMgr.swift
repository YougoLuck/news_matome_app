//
//  NetworkMgr.swift
//  news_matome
//
//  Created by Youmaru on 2020/01/18.
//  Copyright © 2020 Youmaru. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkMgr: NSObject {

    private let sessionMgr: AFURLSessionManager = {
        let configuration = URLSessionConfiguration.default
        let mgr = AFURLSessionManager.init(sessionConfiguration: configuration)
        let securityPolicy = AFSecurityPolicy.default()
        securityPolicy.allowInvalidCertificates = true
        securityPolicy.validatesDomainName = false
        mgr.securityPolicy = securityPolicy
        return mgr
    }()
    
    
    private func getRequest(method: String, urlString: String, headers: Dictionary<String, String>?) -> URLRequest? {
        let encodeURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard encodeURL != nil else {
            return nil
        }
        let url = URL.init(string: encodeURL!)
        guard let _ = url else {return nil}
        var req = URLRequest.init(url: url!)
        req.httpMethod = method
        if let _headers = headers {
            for (key, value) in _headers {
                req.setValue(value, forHTTPHeaderField: key)
            }
        }
        return req
    }
    
    func post(urlString: String, headers: Dictionary<String, String>?, para: Dictionary<String, Any>?, completeHandler:@escaping(Error?, Any?)->()){
        var req = self.getRequest(method: "POST", urlString: urlString, headers: headers)
        let data = try? JSONSerialization.data(withJSONObject: para as Any, options: [])
        req?.httpBody = data
        guard let _ = req else { return }
        let task = self.sessionMgr.dataTask(with: req!, uploadProgress: nil, downloadProgress: nil) { (response, responeObject, error) in
            completeHandler(error, responeObject)
        }
        task.resume()
    }
    
    func get(urlString: String, headers: Dictionary<String, String>?, para: Dictionary<String, Any>?, completeHandler:@escaping(Error?, Any?)->()) {
        var paraStr = ""
        if let _para = para {
            paraStr += "?"
            for (key, value) in _para{
                paraStr += "\(key)=\(value)&"
            }
            paraStr.removeLast()
        }
        let req = self.getRequest(method: "GET", urlString: urlString + paraStr, headers: headers)
        guard let _ = req else { return }
        let task = self.sessionMgr.dataTask(with: req!, uploadProgress: nil, downloadProgress: nil) { (response, responseObject, error) in
            completeHandler(error, responseObject)
        }
        task.resume()
    }
    
    static let sharedMgr: NetworkMgr = {
        let instance = NetworkMgr()
        return instance
    }()
    
}
