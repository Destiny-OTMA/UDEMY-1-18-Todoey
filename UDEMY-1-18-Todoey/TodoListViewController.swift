//
//  TodoListViewController.swift
//  UDEMY-1-18-Todoey
//
//  Created by Destiny Sopha on 7/16/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  let itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  //MARK - Tableview Datasource Methods
  
  //TODO: Declare numberOfRowsInSection here:
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  // TODO: Declare cellForRowAtIndexPath here:
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
    
    return cell
  }
  
  //MARK - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print(indexPath.row, itemArray[indexPath.row])
    
    
    //TODO: Add/Remove a checkmark to/from the cell
    // if there is a checkmark already in the cell, toggle it off
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    else {
      // If there is no checkmark alraedy in the cell, toggle it on
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
}

