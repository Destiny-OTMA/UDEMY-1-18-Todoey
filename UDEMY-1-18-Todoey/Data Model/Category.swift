//
//  Category.swift
//  UDEMY-1-18-Todoey
//
//  Created by Destiny Sopha on 7/31/19.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name : String = ""
  let items = List<Item>()
}

