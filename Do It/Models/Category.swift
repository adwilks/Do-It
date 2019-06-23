//
//  Category.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/19/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String? = ""
    let items = List<Item>()
    
}
