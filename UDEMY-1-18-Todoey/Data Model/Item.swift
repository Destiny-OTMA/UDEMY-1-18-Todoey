//
//  Item.swift
//  UDEMY-1-18-Todoey
//
//  Created by Destiny Sopha on 7/31/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title : String = ""
  @objc dynamic var done : Bool = false
  @objc dynamic var dateCreated : Date?
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}


