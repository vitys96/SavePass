//
//  Nav Contr + FadeAnimaate.swift
//  SavePass
//
//  Created by Виталий Охрименко on 14/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func fadeInAnimationsNavigationController() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
    }
}

