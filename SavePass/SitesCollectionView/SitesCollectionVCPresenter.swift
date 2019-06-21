//
//  File.swift
//  SavePass
//
//  Created by Виталий Охрименко on 15/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

class SitesCollectionVCPresenter {
    
    weak private var sitesView: SitesCollectionVCProtocol?
    
    let userDefaults = UserDefaults.standard
    var alert: UIAlertController!
    
    
    func attachView(_ viewProtocol: SitesCollectionVCProtocol) {
        self.sitesView = viewProtocol
    }
    
    func changePasswordLogic(vc: UIViewController) {
         alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if userDefaults.bool(forKey: "passwordCreate") && !userDefaults.bool(forKey: "passwordDelete") {
            alertActions(title: "Изменить пароль", style: .default) { (success) in
                self.sitesView?.pinChange()
                
            }
            alertActions(title: "Удалить пароль", style: .destructive) { (success) in
                self.sitesView?.pinDeactive()
                self.userDefaults.set(true, forKey: "passwordDelete")
            }
        }
        if userDefaults.bool(forKey: "passwordDelete") {
            alertActions(title: "Создать пароль", style: .default) { (success) in
                self.sitesView?.pinCreate()
                self.userDefaults.set(false, forKey: "passwordDelete")
                
            }
        }
        
        let defaultAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        alert.addAction(defaultAction)
        
        vc.present(alert, animated: true) {
            self.alert.view.superview?.subviews[1].isUserInteractionEnabled = true
            self.alert.view.superview?.subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController)))
        }
    }
    
    private func alertActions(title: String, style: UIAlertAction.Style, hadler: ((UIAlertAction) -> Void)? = nil) {
        let action = UIAlertAction(title: title, style: style, handler: hadler)
        alert.addAction(action)
    }
    
    @objc private func dismissAlertController(){
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    func checkEntryAppPassLogic() {
        if userDefaults.bool(forKey: "passwordDelete") {
            return
        }
        
        if !userDefaults.bool(forKey: "passwordCreate") {
            self.sitesView?.pinCreate()
            userDefaults.set(true, forKey: "passwordCreate")
        }
        else {
           self.sitesView?.pinValidate()
        }
    }
    
    func checkCountOfSiteLogic(button: UIButton, vc: UIViewController) {
        if DBManager.sharedInstance.getDataFromSiteList().count == 0 {
            self.addNewSiteButton(emptySitesButton: button, vc: vc)
            self.sitesView?.newSiteBtnAddTarget(button: button)
        }
        else {
            self.hideNewSiteButton(emptySitesButton: button)
        }
    }
    
    private func addNewSiteButton(emptySitesButton: UIButton, vc: UIViewController) {
        emptySitesButton.setBackgroundImage(UIImage(named: "plus"), for: .normal)
        vc.view.addSubview(emptySitesButton)
        
        emptySitesButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.height / 3, width: 50, height: 50)
        emptySitesButton.center.x = vc.view.center.x
    }
    
    private func hideNewSiteButton(emptySitesButton: UIButton) {
        emptySitesButton.removeFromSuperview()
    }
}
