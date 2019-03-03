//
//  PreAddNewSiteCollectionVC.swift
//  Passwd
//
//  Created by Виталий Охрименко on 01/03/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class PreAddNewSiteCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0)
        
        navigationItem.title = "Teams"
        navigationController?.navigationBar.barTintColor = UIColor.customRedColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                   NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        collectionView?.register(PreAddNSCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PreAddNSCollectionViewCell
        cell.team = teams[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 16, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
