//
//  DetailVC.swift
//  news_matome
//
//  Created by Youmaru on 2020/1/19.
//  Copyright © 2020 Youmaru. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

class DetailVC: UIViewController {
    var item: NewsItem?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.gray
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let containView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.black
        view.alpha = 0.5
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let webBtn: UIButton = {
        let btn = UIButton()
        btn.imageView?.contentMode = .scaleAspectFit
        btn.setImage(UIImage.init(named: "web"), for: .normal)
        return btn
    }()
    
    
    convenience init(item: NewsItem){
        self.init()
        self.item = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageBrowser()
        self.handleItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupImageBrowser(){
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.containView)
        self.scrollView.delegate = self
        let containerH = 140.0
        self.containView.snp.makeConstraints { (make) in
            make.height.equalTo(containerH)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.containView.addSubview(self.titleLabel)
        self.containView.addSubview(self.webBtn)
        let webBtnWH = 50.0
        let inset = 5.0
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(inset)
            make.height.lessThanOrEqualToSuperview().offset(inset*3)
            make.width.lessThanOrEqualToSuperview().offset(-(inset*3 + webBtnWH))
        }
        self.webBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-inset)
            make.height.equalToSuperview()
            make.width.equalTo(webBtnWH)
        }
        
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.scrollView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-containerH)
        }
        
        self.scrollView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(scrollTouch)))
        self.view.updateConstraints()
        self.webBtn.addTarget(self, action: #selector(webBtnClick), for:.touchUpInside)
    }
}

extension DetailVC {
    func handleItem() {
        guard self.item != nil else {
            return
        }
        if let urlString = self.item!.img_link {
            let url = URL(string: urlString)
            self.imageView.kf.setImage(with: url)
        }
        var titleText = self.item?.title
        guard titleText != nil else {
            return
        }
        titleText! += "\n\n\(item!.source)"
        if let time = self.item?.pub_time{
            titleText! += " \(time)"
        }
        self.titleLabel.text = titleText
    }
    
    @objc func scrollTouch() {
        var newAlpha: CGFloat = 0.0
        if self.containView.alpha == 0.0 {
            newAlpha = 0.5
        }
        UIView.animate(withDuration: 0.3) {
            self.containView.alpha = newAlpha
        }
    }
    
    @objc func webBtnClick(){
        if let link = item?.news_link{
            let url = URL(string: link)
            guard url != nil else {
                return
            }
            let sf = SFSafariViewController(url: url!)
            sf.modalPresentationStyle = .currentContext
            self.present(sf, animated: true, completion: nil)
        }
    }
}


extension DetailVC: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
