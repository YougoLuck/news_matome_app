//
//  HomeVC.swift
//  news_matome
//
//  Created by Youmaru on 2020/01/18.
//  Copyright © 2020 Youmaru. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    let yahooBtn: SourceBtn = {
        let btn = SourceBtn.init()
        return btn
    }()
    let nhkBtn: SourceBtn = {
        let btn = SourceBtn.init()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white,
                                                                        .font:UIFont.systemFont(ofSize: 23)]
        self.title = "ニュースまとめ"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "戻る",
                                                                     style: .plain,
                                                                     target: nil,
                                                                     action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "決定",
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(okBtnClick(sender:)))
        self.view.backgroundColor = UIColor.init(red: 102/255.0, green: 102/255.0, blue: 153/255.0, alpha: 1)
        
        self.configSourcesView()
    }
    
    func configSourcesView() {
        self.setupBtn(btn: self.yahooBtn, title: "ヤフーニュース")
        self.setupBtn(btn: self.nhkBtn, title: "NHKニュース")
        let container = UIView.init()
        container.addSubview(self.yahooBtn)
        container.addSubview(self.nhkBtn)
        self.view.addSubview(container)
        let inset = 25.0
        container.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).offset(-inset*3)
            make.height.equalTo(self.view.snp.height).multipliedBy(1/3.0)
            make.width.equalTo(self.view.snp.width).offset(-inset)
        }
        self.yahooBtn.snp.makeConstraints { (make) in
            make.top.equalTo(container.snp.top)
            make.centerX.equalTo(container.snp.centerX)
            make.height.equalTo(container.snp.height).multipliedBy(1/2.0).offset(-inset)
            make.width.equalTo(container.snp.width)
        }
        self.nhkBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(container.snp.bottom)
            make.centerX.equalTo(container.snp.centerX)
            make.size.equalTo(self.yahooBtn.snp.size)
        }
    }
    
    func setupBtn(btn: UIButton, title: String) {
        btn.setImage(UIImage.init(named: "source_check"), for: .selected)
        btn.setImage(UIImage.init(named: "source_cancel"), for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        btn.addTarget(self, action: #selector(sourceBtnClick(sender:)), for: .touchUpInside)
        btn.isSelected = true
    }
    
    @objc func sourceBtnClick(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func okBtnClick(sender: UIBarButtonItem) {
        var source: Array<String> = []
        if self.nhkBtn.isSelected {
            source.append("nhk")
        }
        if self.yahooBtn.isSelected {
            source.append("yahoo")
        }
        
        let newsVC = NewsVC(sources: source)
        self.navigationController?.pushViewController(newsVC, animated: true)
    }
}
