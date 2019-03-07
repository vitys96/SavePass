//
//  PreAddNSCollectionViewCell.swift
//  Passwd
//
//  Created by Виталий Охрименко on 01/03/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class PreAddNSCollectionViewCell: UICollectionViewCell {
    
    var site: Team? {
        didSet {
            guard let teamImage = site?.image else { return }
            guard let teamName = site?.name else { return }
            
            teamImageVieW.image = UIImage(named: teamImage)
            teamNameLabel.text = teamName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setCellShadow()
    }
    
    func setup() {
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(teamImageVieW)
        self.addSubview(teamNameLabel)
        
        teamImageVieW.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        teamNameLabel.anchor(top: teamImageVieW.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    let teamImageVieW: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let teamNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
