//
//  Category.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/19/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
