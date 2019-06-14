//
//  ModalVCPresenter.swift
//  SavePass
//
//  Created by Виталий Охрименко on 13/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit


class ModalVcPresenterPresenter {
    
    weak private var booksView: ModalVCViewProtocol?
    
    func shareSite(vc: UIViewController) {
        
        let alertController = UIAlertController(title: "Вы уверены, что хотите поделиться?", message: "Имя сайта, его адрес, логин и пароль станут известны отправителю", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Поделиться", style: .default) { (action) in
            let items = [self]
            
            let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            vc.present(activityController, animated: true)
        }
        alertController.addAction(deleteAction)
        alertController.addAction(okAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
}
