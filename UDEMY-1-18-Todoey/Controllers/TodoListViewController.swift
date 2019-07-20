//
//  TodoListViewController.swift
//  UDEMY-1-18-Todoey
//
//  Created by Destiny Sopha on 7/16/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  var itemArray = [Item]()
  
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    print(dataFilePath)
    
    loadItems()
    
  }
  
  //MARK - Tableview Datasource Methods
  
  //TODO: Declare numberOfRowsInSection here:
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  // TODO: Declare cellForRowAtIndexPath here:
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    
    cell.textLabel?.text = item.title
    
    // Ternary operator ==>
    // value = condition ? valueIfTrue : valueIfFalse
    cell.accessoryType = item.done ? .checkmark : .none
    
    return cell
  }
  
  // MARK - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    //TODO: Add/Remove a checkmark to/from the cell
    // if there is a checkmark already in the cell, toggle it off
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    saveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  
  // MARK - Add New Item to the list
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button on our UIAlert
      let newItem = Item()
      newItem.title = textField.text!
      
      self.itemArray.append(newItem)
      
      self.saveItems()
      
    }
    
    // add a text field to the pop up alert
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  //MARK - Model Manipulation Methods
  
  // code the array data into a format that can be saved to the Property List file
  func saveItems() {
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print("Error encoding item array, \(error)")
    }
    
    self.tableView.reloadData()
  }
  
  
  // decode the data from the Property List File into a format that can be saved to the Array
  func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!) {
      let decoder = PropertyListDecoder()
      do {
        itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print("Error encoding item array, \(error)")
      }
    }
  }
  
  
}
