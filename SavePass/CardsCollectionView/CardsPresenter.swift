////
////  CardsPresenter.swift
////  SavePass
////
////  Created by Виталий Охрименко on 28/06/2019.
////  Copyright © 2019 kaboo. All rights reserved.
////
//import UIKit
//import PayCardsRecognizer
//
//
//class CardsPresenter {
//    
//    var alert: UIAlertController!
//    
//    func addCardVariation() {
//        alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        alertActions(title: "Создать пароль", style: .default) { (success) in
//            
//        }
//    }
//    
//    let defaultAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
//    alert.addAction(defaultAction)
//    
//    vc.present(alert, animated: true) {
//    self.alert.view.superview?.subviews[1].isUserInteractionEnabled = true
//    self.alert.view.superview?.subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController)))
//    }
//    
//    
//    private func alertActions(title: String, style: UIAlertAction.Style, hadler: ((UIAlertAction) -> Void)? = nil) {
//        let action = UIAlertAction(title: title, style: style, handler: hadler)
//        alert.addAction(action)
//    }
//    
//}
