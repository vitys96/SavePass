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
    
    var cardItem: CardList? {
        didSet {
            nameOfCard.text = cardItem?.cardName
            cardNumber.text = notVisibleString(string: cardItem!.cardNumber)
            
            let cardHexColor = cardItem?.cardColor
            backgroundLayer.backgroundColor = UIColor(hexString: cardHexColor!)
            
            ownerName.text = cardItem?.ownerName.uppercased()
            dateOfExpiry.text = cardItem?.dateExpiry
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setCellShadow()
    }
    
    private func setup() {
        
        self.addSubview(backgroundLayer)
        [cardNumber, imageView, nameOfCard, ownerName, dateOfExpiry].forEach { (item) in
            self.backgroundLayer.addSubview(item)
        }
        
        backgroundLayer.fillSuperview()
    
        
        
        imageView.anchor(top: backgroundLayer.topAnchor,
                         leading: backgroundLayer.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0),
                         size: CGSize(width: 30, height: 30))
        
        nameOfCard.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        nameOfCard.anchor(top: nil,
                          leading: imageView.trailingAnchor,
                          bottom: nil,
                          trailing: backgroundLayer.trailingAnchor,
                          padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0))
        
        cardNumber.anchor(top: imageView.bottomAnchor,
                          leading: backgroundLayer.leadingAnchor,
                          bottom: nil,
                          trailing: backgroundLayer.trailingAnchor,
                          padding: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0))
        
        dateOfExpiry.anchor(top: nil,
                            leading: backgroundLayer.leadingAnchor,
                            bottom: backgroundLayer.bottomAnchor,
                            trailing: nil,
                            padding: UIEdgeInsets(top: 0, left: 5, bottom: 2, right: 0))
        
        ownerName.anchor(top: nil,
                         leading: backgroundLayer.leadingAnchor,
                         bottom: dateOfExpiry.topAnchor,
                         trailing: backgroundLayer.trailingAnchor,
                         padding: UIEdgeInsets(top: 0, left: 5, bottom: 2, right: 0))
        
        

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
    
    let nameOfCard: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let cardNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        return label
    }()
    
    let ownerName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let dateOfExpiry: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.minimumScaleFactor = 0.8
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CardsColViewCell {
    private func notVisibleString(string: String) -> String {
        
        let cardNumberSplit = string.split(separator: " ")
        let notVisibleString = "#### #### #### \(cardNumberSplit[3])"
        
        return notVisibleString
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


