//
//  CardsColVC.swift
//  SavePass
//
//  Created by Виталий Охрименко on 17/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit
import SPStorkController
import RealmSwift

class CardsColVC: UICollectionViewController {
    
    let realm = try! Realm()
    var selectedSite: SiteList!
    
    var arrayOfCards = [CardList]()
    
    @IBAction func addNewCard(_ sender: UIBarButtonItem) {
        self.pushToAddSite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureColView()
    }
    
    private func configureColView() {
        collectionView?.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0)
        collectionView?.register(CardsColViewCell.self, forCellWithReuseIdentifier: CardsColViewCell.reuseIdentifier)
    }
    
    private func pushToAddSite() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "NewCardTableVC") as? NewCardTableVC else { return }
        
        fadeInAnimationsNavigationController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func configureCell(cell: CardsColViewCell, indexPath: IndexPath) {
        let cardItem = DBManager.sharedInstance.getDataFromCardList()[indexPath.item] as CardList
        cell.loginLabel.text = cardItem.cardNumber
        let cardHexColor = cardItem.cardColor
        cell.backgroundLayer.backgroundColor = UIColor(hexString: cardHexColor)
    }
}

extension CardsColVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DBManager.sharedInstance.getDataFromCardList().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardsColViewCell.reuseIdentifier, for: indexPath) as? CardsColViewCell else { return UICollectionViewCell() }
        
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension CardsColVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 16, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}