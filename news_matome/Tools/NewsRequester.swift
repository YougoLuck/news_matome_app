//
//  NewsRequester.swift
//  news_matome
//
//  Created by Youmaru on 2020/01/19.
//  Copyright © 2020 Youmaru. All rights reserved.
//

import UIKit

let DEFAULT_USER = ""
let DEFAULT_PW = ""
let APPKEY = ""
let APPID = ""
let API_BASE = ""
let USER_DEFAULT = "USER_DEFAULT"

class NewsRequester: NSObject {

    let headers: Dictionary<String, String> = ["Content-type": "application/json",
                                               "X-LC-Id": APPID,
                                               "X-LC-Key": APPKEY]
    
    var accessToken:String?
    func login(completeHandler:@escaping(String?)->()){
        
        guard self.accessToken == nil else {
            completeHandler(self.accessToken)
            return
        }
        
        let defaultStand = UserDefaults.standard
        self.accessToken = defaultStand.string(forKey: USER_DEFAULT)
        
        guard self.accessToken == nil else {
            completeHandler(self.accessToken)
            return
        }
        
        let urlString = "\(API_BASE)/1.1/login"
        NetworkMgr.sharedMgr.post(urlString: urlString,
                                  headers: self.headers,
                                  para: ["username":DEFAULT_USER, "password":DEFAULT_PW])
        { (error, responseObject) in
            defer {
                completeHandler(self.accessToken)
            }
            if let _ = error { return }
            if let json = (responseObject as? Dictionary<String, Any>) {
                self.accessToken = json["sessionToken"] as? String
                if let token = self.accessToken {
                    defaultStand.set(token , forKey: USER_DEFAULT)
                }
            }
        }
    }
    
    func getNewsItem(page: Int, cnt: Int, sources: [String], completeHandler:@escaping(Array<Any>?)->()) {
        login { (token) in
            guard token != nil && sources.count != 0  else {
                completeHandler(nil)
                return
            }
            let urlString = "\(API_BASE)/1.1/classes/News"
            var headers = self.headers
            headers["X-LC-Session"] = token
            
            var sourcesStr = ""
            for source in sources{
                sourcesStr += "\"\(source)\","
            }
            sourcesStr.removeLast()
            let whereCondi = "{\"website\":{\"$in\":[\(sourcesStr)]}}"
            
            let para: [String : Any] = ["where": whereCondi,
                                        "order": "-createdAt",
                                        "limit": cnt,
                                        "skip": cnt * page]

            NetworkMgr.sharedMgr.get(urlString: urlString, headers: headers, para: para) { (error, response) in
                
                guard error == nil && response as? Dictionary<String, Any> != nil else {
                    completeHandler(nil)
                    return
                }
                let dataDict = response as! Dictionary<String, Any>
                completeHandler(dataDict["results"] as? Array<Any>)
                
            }
            
        }
    }
    
    
    static let sharedMgr: NewsRequester = {
        let instance = NewsRequester()

        return instance
    }()
}
