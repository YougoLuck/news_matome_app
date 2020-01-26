//
//  NewsCell.swift
//  news_matome
//
//  Created by Youmaru on 2020/01/19.
//  Copyright © 2020 Youmaru. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCell: UITableViewCell {
    let newsImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white
        return imageView
    }()
    let newsLabel: UILabel = {
        let label = UILabel.init()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
    let sourceLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.gray
        self.contentView.addSubview(self.newsImageView)
        self.contentView.addSubview(self.newsLabel)
        self.contentView.addSubview(self.sourceLabel)
        self.setupSubviewAutolayout()
    }
    
    func setupSubviewAutolayout() {
        let inset = 5.0
        self.newsImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(inset)
            make.height.equalToSuperview().offset(-inset*2)
            make.width.equalTo(self.contentView.snp.height).offset(-inset*2)
            make.centerY.equalToSuperview()
        }
        self.newsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.newsImageView.snp.right).offset(inset)
            make.top.equalToSuperview().offset(inset)
            make.right.lessThanOrEqualToSuperview().offset(-inset)
            make.height.lessThanOrEqualToSuperview().offset(-inset*2).multipliedBy(2/3.0)
        }
        
        self.sourceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.newsImageView.snp.bottom)
            make.left.equalTo(self.newsLabel.snp.left)
            make.right.lessThanOrEqualToSuperview().offset(-inset)
            make.height.lessThanOrEqualToSuperview().offset(-inset*2).multipliedBy(1/3.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension NewsCell {
    func handleModel(item: NewsItem) {
        if let urlString = item.img_link{
            self.newsImageView.kf.setImage(with: URL(string: urlString), placeholder: UIImage(named: "newsImagePH"))
        }
        self.newsLabel.text = item.title
        var displayStr = "メディア: \(item.source)"
        if let time = item.pub_time{
            displayStr += "\n\(time)"
        }
        self.sourceLabel.text = displayStr
    }
}
