//
//  SourceBtn.swift
//  news_matome
//
//  Created by Youmaru on 2020/01/19.
//  Copyright © 2020 Youmaru. All rights reserved.
//

import UIKit

class SourceBtn: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let superSize = self.bounds.size
        let inset: CGFloat = 10.0
        self.imageView?.frame = CGRect(x: inset, y: 0, width: superSize.height, height: superSize.height)
        let x = (self.imageView?.frame ?? CGRect.zero).maxX + inset
        self.titleLabel?.frame = CGRect(x: x, y: 0, width: superSize.width - x, height: superSize.height)
    }
}
