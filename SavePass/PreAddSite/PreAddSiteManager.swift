//
//  PreAddSiteManager.swift
//  Passwd
//
//  Created by Виталий Охрименко on 01/03/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import Foundation

struct Team {
    let image: String?
    let name: String?
    let address: String?
}

var preAddSites = [
    Team(image: "1default", name: "Другое", address: nil),
    Team(image: "twitter", name: "Twitter", address: "twitter.com"),
    Team(image: "facebook", name: "Facebook", address: "facebook.com"),
    Team(image: "gmail", name: "Gmail", address: "gmail.com"),
    Team(image: "youtube", name: "YouTube", address: "youtube"),
    Team(image: "skype", name: "Skype", address: "skype.com"),
    Team(image: "vk", name: "VK", address: "vk.com"),
    Team(image: "avito", name: "Avito", address: "avito.ru"),
    Team(image: "instagram", name: "Instagram", address: "instagram.com"),
    Team(image: "flickr", name: "Flickr", address: "flickr.com")
]

let sorted = preAddSites.sorted(by: {
    guard let nameOne = $0.image, let nameTwo = $1.image else { return false }
    return nameOne < nameTwo
})
