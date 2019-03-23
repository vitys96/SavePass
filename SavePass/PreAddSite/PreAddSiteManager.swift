//
//  PreAddSiteManager.swift
//  Passwd
//
//  Created by Виталий Охрименко on 01/03/2019.
//  Copyright © 2019 kaboo. All rights reserved.
//

import Foundation

struct SiteObject {
    let image: String?
    let name: String?
    let address: String?
}

var preAddSites = [
    SiteObject(image: "1default", name: "Другое", address: nil),
    SiteObject(image: "twitter", name: "Twitter", address: "twitter.com"),
    SiteObject(image: "facebook", name: "Facebook", address: "facebook.com"),
    SiteObject(image: "gmail", name: "Gmail", address: "gmail.com"),
    SiteObject(image: "youtube", name: "YouTube", address: "youtube"),
    SiteObject(image: "skype", name: "Skype", address: "skype.com"),
    SiteObject(image: "vk", name: "VK", address: "vk.com"),
    SiteObject(image: "instagram", name: "Instagram", address: "instagram.com"),
    SiteObject(image: "flickr", name: "Flickr", address: "flickr.com"),
    SiteObject(image: "twitch", name: "Twitch", address: "twitch.com"),
    SiteObject(image: "aliExpress", name: "AliExpress", address: "aliexpress.ru"),
    SiteObject(image: "avito", name: "Avito", address: "aliexpress.ru"),
    SiteObject(image: "joom", name: "Joom", address: "joom.ru"),
    SiteObject(image: "ok", name: "OK", address: "aliexpress.ru"),
    SiteObject(image: "amazon", name: "Amazon", address: "amazon.com"),
    SiteObject(image: "dropbox", name: "Dropbox", address: "dropbox.com"),
    SiteObject(image: "github", name: "Github", address: "github.com"),
    SiteObject(image: "google", name: "Google", address: "myaccount.google.com"),
    SiteObject(image: "ebay", name: "Ebay", address: "ebay.com"),
    SiteObject(image: "microsoft", name: "Microsoft", address: "microsoft.com"),
    SiteObject(image: "netflix", name: "Netflix", address: "netflix.com"),
    SiteObject(image: "reddit", name: "Reddit", address: "reddit.com")
    
]

let sorted = preAddSites.sorted(by: {
    guard let nameOne = $0.image, let nameTwo = $1.image else { return false }
    return nameOne < nameTwo
})
