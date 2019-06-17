//
//  PreAddNSCollectionViewCell.swift
//  Passwd
//
//  Created by Виталий Охрименко on 01/03/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class PreAddNSCollectionViewCell: UICollectionViewCell {
    
    var site: SiteObject? {
        didSet {
            guard let teamImage = site?.image, let teamName = site?.name else { return }
            siteImageView.image = UIImage(named: teamImage)
            siteNameLabel.text = teamName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setCellShadow()
    }
    
    
    func setup() {
        self.backgroundColor = UIColor.white
        
        
        self.addSubview(siteImageView)
        self.addSubview(siteNameLabel)
        
        siteImageView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             bottom: nil,
                             trailing: trailingAnchor,
                             padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0),
                             size: CGSize(width: 0, height: 50))
        
        siteNameLabel.anchor(top: siteImageView.bottomAnchor,
                             leading: leadingAnchor,
                             bottom: nil,
                             trailing: trailingAnchor,
                             padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
    }
    
    let siteImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let siteNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
