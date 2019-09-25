//
//  Items.swift
//  ShoppingApp
//
//  Created by Fazlan on 9/17/19.
//  Copyright © 2019 Fazlan. All rights reserved.
//

import Foundation
import RealmSwift

class Items: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title: String = ""
    @objc dynamic var itemDesc: String = ""
    @objc dynamic var itemPrice: String = ""
    @objc dynamic var image: Data? = nil
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func incrementId() -> Int {
        return (try! Realm().objects(Items.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}



