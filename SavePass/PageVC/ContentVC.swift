//
//  ContentVC.swift
//  SavePass
//
//  Created by Виталий Охрименко on 23/03/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class ContentVC: UIViewController {
    
    @IBOutlet weak var pageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    var imageName = ""
    var labelText = ""
    var index = 0
    
    @IBAction func pageBtnAction(_ sender: Any) {
        switch index {
        case 0:
            let pageVC = parent as! PageVC
            pageVC.nextVC(atIndex: index)
        case 2:
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "wasWatched")
            userDefaults.synchronize()
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addVerticalGradientLayer(topColor: UIColor(named: "#ecf0f1")!, bottomColor: UIColor(named: "#add3e5")!)
        
        switch index {
        case 0: pageButton.isHidden = true
        case 1: pageButton.isHidden = true
        case 2: pageButton.setTitle("Открыть", for: .normal)
        default:
            break
        }
        pageControl.numberOfPages = 3
        pageControl.currentPage = index
        
        imageView.image = UIImage(named: imageName)
        label.text = labelText
    }
}
