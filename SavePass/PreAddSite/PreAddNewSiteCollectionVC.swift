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
    
    let sorted = teams.sorted(by: {
        guard let nameOne = $0.name, let nameTwo = $1.name else { return false }
        return nameOne < nameTwo
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0)
        
        
        collectionView?.register(PreAddNSCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PreAddNSCollectionViewCell

       
        
        cell.team = sorted[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 16, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "NewSiteTableVC") as? NewSiteTableVC else { return }
        
        guard let sortedSiteImageName = sorted[indexPath.row].image else { return }
        vc.imageViewString = sortedSiteImageName
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
