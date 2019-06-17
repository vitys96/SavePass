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
    
    var site: Site? {
        didSet {
            guard let siteImage = site?.image else { return }
            guard let loginName = site?.name else { return }
            
            siteImageView.image = UIImage(named: siteImage)
            loginLabel.text = loginName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    func setup() {
//        self.backgroundColor = .white
        
        self.addSubview(backgroundLayer)
        self.backgroundLayer.addSubview(siteImageView)
        self.backgroundLayer.addSubview(grayView)
        self.backgroundLayer.addSubview(loginLabel)
        
        backgroundLayer.fillSuperview()
        siteImageView.anchor(top: backgroundLayer.topAnchor,
                             leading: backgroundLayer.leadingAnchor,
                             bottom: nil,
                             trailing: backgroundLayer.trailingAnchor,
                             padding: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10),
                             size: CGSize(width: 52, height: 52))
        
        grayView.anchor(top: nil,
                        leading: backgroundLayer.leadingAnchor,
                        bottom: backgroundLayer.bottomAnchor,
                        trailing: backgroundLayer.trailingAnchor)
        loginLabel.anchor(top: nil,
                          leading: backgroundLayer.leadingAnchor,
                          bottom: grayView.bottomAnchor,
                          trailing: backgroundLayer.trailingAnchor)
    }
    
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
    
    let backgroundLayer: UIView = {
        let backLayer = UIView()
        backLayer.translatesAutoresizingMaskIntoConstraints = false
        backLayer.layer.cornerRadius = 5
        backLayer.backgroundColor = .white
        return backLayer
    }()
    
    let siteImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
    }()
    
    let grayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0)
        return view
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


