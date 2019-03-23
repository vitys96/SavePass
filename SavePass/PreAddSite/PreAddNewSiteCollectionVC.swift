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
        updateUI()
        
    }
    @IBAction func cancelBarButtonItem(_ sender: UIBarButtonItem) {
        
        fadeInAnimationsNavigationController()
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
    func updateUI() {
        collectionView?.backgroundColor = UIColor(hexValue: "#dedede", alpha: 1.0)
        collectionView?.register(PreAddNSCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        
    }
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "About Us"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Ррараар"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    
    // MARK: - Table View data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return preAddSites.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PreAddNSCollectionViewCell
        if indexPath.item == 0 {
            let layer = cell.layer
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 3
            layer.shadowColor = UIColor.red.cgColor
            layer.shadowOpacity = 1
            layer.frame = cell.frame
            cell.teamNameLabel.textColor = .black
        }
        
        cell.site = sorted[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 16, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    
    
    // MARK: - Table View delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "NewSiteTableVC") as? NewSiteTableVC else { return }
        let sortedIndexPathRow = sorted[indexPath.row]
        
        vc.selectedSite = nil
        guard let sortedSiteImageName = sortedIndexPathRow.image else { return }
        vc.imageViewString = sortedSiteImageName
        vc.nameOfSiteString = sortedIndexPathRow.name ?? ""
        vc.siteAddressString = sortedIndexPathRow.address ?? ""
        
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
