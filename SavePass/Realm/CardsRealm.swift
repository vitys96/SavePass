//
//  CardsRealm.swift
//  SavePass
//
//  Created by Виталий Охрименко on 19/06/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import UIKit
import RealmSwift

class CardList: Object {
    
    @objc dynamic var cardID = -1
    @objc dynamic var cardName = ""
    @objc dynamic var ownerName = ""
    @objc dynamic var cardNumber = ""
    @objc dynamic var dateExpiry = ""
    @objc dynamic var cvNumber = ""
    @objc dynamic var cardColor = ""
    
    override static func primaryKey() -> String? {
        return "cardID"
    }
    
}
