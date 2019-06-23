//
//  Item.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/19/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var cellColor: String? = ""
    // Represents the backward relationship to items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
