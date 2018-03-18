//
//  Category.swift
//  TodoE
//
//  Created by Franklin Siqueira on 13/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryTb: Object {
    @objc dynamic var category: String = ""
    let items = List<ItemTb>()
}
