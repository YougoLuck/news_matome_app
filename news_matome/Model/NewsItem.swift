//
//  NewsItem.swift
//  news_matome
//
//  Created by Youmaru on 2020/01/19.
//  Copyright © 2020 Youmaru. All rights reserved.
//


import UIKit
import HandyJSON


class NewsItem: HandyJSON {
    var title: String?
    var img_link: String?
    var news_link: String?
    var pub_time: String?
    var source: String = "不明"
    var website: String?
    
    func didFinishMapping() {
        switch self.website {
        case "yahoo":
            self.source = "ヤフーニュース"
        case "nhk":
            self.source = "NHKニュース"
        default:
            self.source = "不明"
        }
        
    }
    required init() {}
    

}


