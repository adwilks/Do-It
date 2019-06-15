//
//  item.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/15/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import Foundation

class Item {
    var title: String
    var isDone: Bool
    
    init(_ newTitle: String) {
        title = newTitle
        isDone = false
    }
}
