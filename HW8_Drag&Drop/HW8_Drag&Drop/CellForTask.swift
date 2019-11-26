//
//  CellForTask.swift
//  HW8_Drag&Drop
//
//  Created by Roman Cheremin on 26/11/2019.
//  Copyright © 2019 Daria Cheremina. All rights reserved.
//

import UIKit

/// Task Collection View Cell
class TaskCell: UICollectionViewCell {
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        descLabel.numberOfLines = 0 // set this value to avoid this label being longer than source cell view
//        descLabel.lineBreakMode = .byWordWrapping
//    }
//    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.21, green:0.62, blue:0.58, alpha:1.0)
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.21, green:0.62, blue:0.58, alpha:1.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView: UIImageView = {
            let imgView = UIImageView(frame: CGRect(x: self.bounds.width - 50, y: self.bounds.height - 50, width: 30, height: 30))
            imgView.tag = 21
            imgView.image = UIImage(named: "tick")
            imgView.alpha = 0
            return imgView
        }()
        
        self.backgroundColor = UIColor(red:0.87, green:0.95, blue:0.96, alpha:1.0)
        
        // shadow setup
        self.layer.cornerRadius = 4
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        // set labels' frame
        titleLabel.frame = CGRect(x: 4, y: 2, width: self.frame.width - 8, height: 20)
        descLabel.frame = CGRect(x: 4, y: 26, width: self.frame.width - 8, height: 0)
        
        
        // delimiter line
        let lineView = UIView(frame: CGRect(x: 2, y: 24, width: frame.width - 4, height: 1))
        lineView.backgroundColor = UIColor(red:0.21, green:0.62, blue:0.58, alpha:1.0)
        
        
        
        contentView.addSubview(descLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        
    }
    
    // this function calls from collectionView cellForItem to put values into text fields
    func setupCell(with task: Task) {
        titleLabel.text = task.title
        descLabel.text = task.desc
//        descLabel.numberOfLines = 0
//        descLabel.lineBreakMode = .byWordWrapping
        
        descLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

