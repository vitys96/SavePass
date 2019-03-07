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
}

var preAddSites = [Team(image: "twitter", name: "Twitter"),
             Team(image: "facebook", name: "Facebook"),
             Team(image: "gmail", name: "Gmail"),
             Team(image: "youtube", name: "youtube"),
             Team(image: "skype", name: "Skype"),
             Team(image: "vk", name: "VK"),
             Team(image: "avito", name: "Avito"),
             Team(image: "instagram", name: "Instagram"),
             Team(image: "flickr", name: "Flickr")]

let sorted = preAddSites.sorted(by: {
    guard let nameOne = $0.name, let nameTwo = $1.name else { return false }
    return nameOne < nameTwo
})
