//
//  SiteList.swift
//  Passwd
//
//  Created by Виталий Охрименко on 20/02/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SiteList: Object {
    @objc dynamic var siteImageView: Data?
    @objc dynamic var siteName = ""
    @objc dynamic var siteAddress = ""
    @objc dynamic var siteLogin = ""
    @objc dynamic var sitePassword = ""
    
}
