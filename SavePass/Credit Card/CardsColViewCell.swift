//
//  CardsColViewCell.swift
//  SavePass
//
//  Created by Виталий Охрименко on 17/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class CardsColViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "Cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        
        self.addSubview(backgroundLayer)
        self.backgroundLayer.addSubview(loginLabel)
        self.backgroundLayer.addSubview(imageView)
        
        backgroundLayer.fillSuperview()
    
        loginLabel.anchor(top: nil,
                          leading: backgroundLayer.leadingAnchor,
                          bottom: backgroundLayer.bottomAnchor,
                          trailing: backgroundLayer.trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        
        imageView.anchor(top: backgroundLayer.topAnchor,
                         leading: backgroundLayer.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0),
                         size: CGSize(width: 35, height: 35))
    }
    
    let backgroundLayer: UIView = {
        let backLayer = UIView()
        backLayer.translatesAutoresizingMaskIntoConstraints = false
        backLayer.layer.cornerRadius = 5
        backLayer.backgroundColor = .white
        return backLayer
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "credit-card")
        return imageView
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardsColViewCell {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }
    
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)? = nil) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: 0.96, y: 0.96)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }
}


