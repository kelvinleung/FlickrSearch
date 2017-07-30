//
//  FlickrCell.swift
//  FlickrSearch
//
//  Created by Kelvin Leung on 30/07/2017.
//  Copyright © 2017 Kelvin Leung. All rights reserved.
//

import UIKit

class FlickrCell: UICollectionViewCell {
    
    let photo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photo)
        
        photo.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
