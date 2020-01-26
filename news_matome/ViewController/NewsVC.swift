//
//  NewsVC.swift
//  news_matome
//
//  Created by Youmaru on 2020/01/18.
//  Copyright © 2020 Youmaru. All rights reserved.
//

import UIKit
import SnapKit
import ESPullToRefresh


class NewsVC: UIViewController {
    private var currentPage = 0
    private let itemCnt = 20
    private var newsItems: Array<NewsItem> = []
    private var sources: Array<String> = []
    private let tableView : UITableView = {
        let tableView = UITableView.init()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.gray
        return tableView
    }()
    
    convenience init(sources: Array<String>) {
        self.init()
        self.sources = sources
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ニュースまとめ"
        self.configTableView()
        self.tableView.es.startPullToRefresh()
    }
    
    private func configTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.snp.center)
            make.size.equalTo(self.view.snp.size)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.es.addPullToRefresh { [unowned self] in
            self.tableView.es.stopPullToRefresh()
            self.currentPage = 0
            self.loadData { (items) in
                self.newsItems = items
                if items.count > 0 {
                    self.tableView.reloadData()
                }
            }
        }

        self.tableView.es.addInfiniteScrolling { [unowned self] in
            self.currentPage += 1
            self.loadData { (items) in
                self.tableView.es.stopLoadingMore()
                if items.count > 0 {
                    let startIndex = self.newsItems.count
                    var indexs: Array<IndexPath> = []
                    for index in startIndex..<(startIndex + items.count) {
                        indexs.append(IndexPath.init(row: index, section: 0))
                    }
                    self.newsItems += items
                    self.tableView.insertRows(at: indexs, with: .none)
                } else {
                    self.tableView.es.noticeNoMoreData()
                }
            }
        }
    }

    
    private func loadData(completeHandler:@escaping(Array<NewsItem>)->()) {
        NewsRequester.sharedMgr.getNewsItem(page: self.currentPage, cnt: self.itemCnt, sources: self.sources) { (response) in
            var result: Array<NewsItem> = []
            if let jsonItems = response {
                for jsonItem in jsonItems {
                    if let item = NewsItem.deserialize(from: jsonItem as? Dictionary) {
                        result.append(item)
                    }
                }
            }
            completeHandler(result)
        }
    }
}


extension NewsVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let NEWS_VC_CELL_IDENTIFY = "NEWS_VC_CELL_IDENTIFY"
        var cell = tableView.dequeueReusableCell(withIdentifier: NEWS_VC_CELL_IDENTIFY)
        if cell == nil {
            cell = NewsCell(style: .default, reuseIdentifier: NEWS_VC_CELL_IDENTIFY)
        }
        (cell as! NewsCell).handleModel(item: self.newsItems[indexPath.row])
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailVC(item: self.newsItems[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
