//
//  Item.swift
//  TodoE
//
//  Created by Franklin Siqueira on 13/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import Foundation
import RealmSwift

class ItemTb: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: CategoryTb.self, property: "items")
    
}
