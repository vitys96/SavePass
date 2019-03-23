//
//  PageVC.swift
//  SavePass
//
//  Created by Виталий Охрименко on 23/03/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class PageVC: UIPageViewController {

    var subheaderArray = [
        "Храните пароли от аккаунтов в одном месте",
        "Вход по паролю и биометрическим данным",
        "Делитесь только теми паролями, которыми хотите",
        
    ]
    var imagesArray = ["1", "2", "3"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        self.view.addVerticalGradientLayer(topColor: UIColor(hex: "#ecf0f1"), bottomColor: UIColor(hex: "#add3e5"))
        
        if let firstVC = displayViewController(atIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Sets the status bar to hidden when the view has finished appearing
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Sets the status bar to visible when the view is about to disappear
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = false
    }
    
    func displayViewController(atIndex index: Int) -> ContentVC? {
        guard index >= 0 else { return nil }
        guard index < subheaderArray.count else { return nil }
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentVC") as? ContentVC else { return nil }
        
        contentVC.imageName = imagesArray[index]
        contentVC.labelText = subheaderArray[index]
        contentVC.index = index
        
        return contentVC
    }
    
    
    func nextVC(atIndex index: Int) {
        if let contentVC = displayViewController(atIndex: index + 1) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
}


extension PageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentVC).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentVC).index
        index += 1
        return displayViewController(atIndex: index)
    }


}
