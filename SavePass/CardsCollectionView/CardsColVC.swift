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
    var selectedCard: CardList?
    
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
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        guard let vc = storyBoard.instantiateViewController(withIdentifier: "RecognizerViewController") as? RecognizerViewController else { return }
//        vc.hidesBottomBarWhenPushed = true
//        
//        fadeInAnimationsNavigationController()
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func configureCell(cell: CardsColViewCell, indexPath: IndexPath) {
        let cardItem = DBManager.sharedInstance.getDataFromCardList()[indexPath.item] as CardList
        
        cell.cardItem = cardItem
    }
    
}

extension CardsColVC: CardModalView {
    
    func changeCardInfo() {

        self.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "NewCardTableVC") as! NewCardTableVC
            vc.isDeletedVisible = true
            guard let selectedCard = self.selectedCard else { return }
            vc.selectedCard = selectedCard
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
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
    
    // MARK: - Table View delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cardItem = DBManager.sharedInstance.getDataFromCardList()[indexPath.item] as CardList
        let modal = CardModalVC()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 380
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        
        modal.delegate = self
        modal.selectedCard = cardItem
        self.selectedCard = cardItem
        
        present(modal, animated: true, completion: nil)
        
        
    }
}

extension CardsColVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 8, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
    }
}


