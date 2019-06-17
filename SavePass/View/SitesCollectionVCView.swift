//
//  SitesCollectionVCView.swift
//  SavePass
//
//  Created by Виталий Охрименко on 15/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit

protocol SitesCollectionVCProtocol: NSObjectProtocol {
    func pinChange()
    func pinDeactive()
    func pinCreate()
    func pinValidate()
    func newSiteBtnAddTarget(button: UIButton)
}
