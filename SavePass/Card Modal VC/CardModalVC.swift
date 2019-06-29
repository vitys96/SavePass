//
//  CardModalVC.swift
//  SavePass
//
//  Created by Виталий Охрименко on 21/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import Foundation

import UIKit
import SPStorkController
import SparrowKit
import RealmSwift
import SPFakeBar

class CardModalVC: UIViewController {
    
    let realm = try! Realm()
    
    var selectedCard: CardList?
    
    weak var delegate: CardModalView?
    
//    weak var presenter = ModalVcPresenterPresenter()
    
    var toggle = true
    
    let navBar = SPFakeBarView(style: .stork)
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    var nameOfCard: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        return label
    }()
    
    var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(hexValue: "#dbdbdb", alpha: 1.0)
        return separator
    }()
    
    var numberOfCard: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = false
        textField.textColor = .black
        textField.adjustsFontSizeToFitWidth = true
        textField.minimumFontSize = 14
        textField.font = UIFont(name: "Halter", size: 17)
        return textField
    }()
    
    var copyButton: UIButton = {
        let copy = UIButton()
        copy.translatesAutoresizingMaskIntoConstraints = false
        copy.setBackgroundImage(UIImage(named: "copyImage"), for: .normal)
        copy.adjustsImageSizeForAccessibilityContentSizeCategory = true
        copy.addTarget(self, action: #selector(copyCardNumber), for: .touchUpInside)
        
        return copy
    }()
    
    var ownerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.1
        label.font = UIFont(name: "Halter", size: 11)
        return label
    }()
    
    var dateOfExpiry: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.font = UIFont(name: "Halter", size: 11)
        return label
    }()
    
    var separatorTwo: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(hexValue: "#dbdbdb", alpha: 1.0)
        return separator
    }()
    
    var cvNumberText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Код безопасности"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    var cvNumber: UITextField = {
        let cvTextField = UITextField()
        cvTextField.translatesAutoresizingMaskIntoConstraints = false
        cvTextField.textColor = .gray
        cvTextField.isEnabled = false
        cvTextField.isSecureTextEntry = true
        cvTextField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return cvTextField
    }()
    
    var showCVNumber: UIButton = {
        let copy = UIButton()
        copy.translatesAutoresizingMaskIntoConstraints = false
        copy.setBackgroundImage(UIImage(named: "visible"), for: .normal)
        copy.contentMode = .scaleAspectFit
        copy.addTarget(self, action: #selector(showHideCv), for: .touchUpInside)
        return copy
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureStartScreen()
        self.setup()
    }
    
    private func configureStartScreen() {
        self.view.backgroundColor = UIColor.white
        self.modalPresentationCapturesStatusBarAppearance = true
        
        self.navBar.rightButton.setTitle("Просмотреть", for: .normal)
        self.navBar.rightButton.addTarget(self, action: #selector(changeInfo), for: .touchUpInside)
        
        [navBar, nameOfCard, separator, numberOfCard, copyButton, ownerLabel, dateOfExpiry, separatorTwo, cvNumber, showCVNumber, cvNumberText].forEach { (item) in
            self.view.addSubview(item)
        }
    }
    
    private func setup() {
        nameOfCard.text = selectedCard?.cardName
        numberOfCard.text = selectedCard?.cardNumber
        numberOfCard.text = selectedCard?.cardNumber
        ownerLabel.text = selectedCard?.ownerName.uppercased()
        dateOfExpiry.text = selectedCard?.dateExpiry
        cvNumber.text = selectedCard?.cvNumber
    }
    
    @objc func copyCardNumber() {
        copyTextInTextField(your: numberOfCard)
    }
    
    @objc func copyPasswordText() {
        copyTextInTextField(your: numberOfCard)
    }
    
    @objc func changeInfo() {
        self.delegate?.changeCardInfo()
    }
    
    @objc private func showHideCv() {
        switchShowHidePasButton(showHideButton: showCVNumber, securityTextEntry: cvNumber, variable: &toggle)
    }
    
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    @available(iOS 11.0, *)
    override public func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        self.updateLayout(with: self.view.frame.size)
    }
    
    func updateLayout(with size: CGSize) {
        
        self.nameOfCard.anchor(top: navBar.bottomAnchor,
                               leading: view.leadingAnchor,
                               bottom: nil,
                               trailing: view.trailingAnchor,
                               padding: UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10))
        
        self.separator.anchor(top: nameOfCard.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: nil,
                              trailing: view.trailingAnchor,
                              padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
                              size: CGSize(width: self.view.size.width, height: 1.5))

        self.numberOfCard.centerXAnchor.constraint(equalTo: self.nameOfCard.centerXAnchor).isActive = true
        self.numberOfCard.anchor(top: separator.bottomAnchor,
                                      leading: nil,
                                      bottom: nil,
                                      trailing: nil,
                                      padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))

        
        copyButton.centerYAnchor.constraint(equalTo: numberOfCard.centerYAnchor).isActive = true
        self.copyButton.anchor(top: nil,
                               leading: numberOfCard.trailingAnchor,
                               bottom: nil,
                               trailing: view.trailingAnchor,
                               padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10),
                               size: CGSize(width: 25, height: 25))
        
        self.ownerLabel.centerXAnchor.constraint(equalTo: self.nameOfCard.centerXAnchor).isActive = true
        self.ownerLabel.anchor(top: numberOfCard.bottomAnchor,
                               leading: nil,
                               bottom: nil,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        
        self.dateOfExpiry.centerXAnchor.constraint(equalTo: self.nameOfCard.centerXAnchor).isActive = true
        self.dateOfExpiry.anchor(top: ownerLabel.bottomAnchor,
                               leading: nil,
                               bottom: nil,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        self.separatorTwo.anchor(top: dateOfExpiry.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: nil,
                              trailing: view.trailingAnchor,
                              padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
                              size: CGSize(width: self.view.size.width, height: 1.5))

        self.cvNumberText.centerXAnchor.constraint(equalTo: self.nameOfCard.centerXAnchor).isActive = true
        self.cvNumberText.anchor(top: separatorTwo.bottomAnchor,
                               leading: nil,
                               bottom: nil,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        
        
        self.cvNumber.centerXAnchor.constraint(equalTo: self.nameOfCard.centerXAnchor).isActive = true
        self.cvNumber.anchor(top: cvNumberText.bottomAnchor,
                                 leading: nil,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 7),
                                 size: CGSize(width: 30, height: 30))
        
        showCVNumber.centerYAnchor.constraint(equalTo: cvNumber.centerYAnchor).isActive = true
        self.showCVNumber.anchor(top: nil,
                               leading: cvNumber.trailingAnchor,
                               bottom: nil,
                               trailing: nil,
                               padding: UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0),
                               size: CGSize(width: 25, height: 25))
    }
}
