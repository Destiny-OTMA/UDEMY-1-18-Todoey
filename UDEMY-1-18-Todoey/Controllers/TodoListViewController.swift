//
//  TodoListViewController.swift
//  UDEMY-1-18-Todoey
//
//  Created by Destiny Sopha on 7/16/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
  
  //Initialize a new access point to the Realm database
  let realm = try! Realm()

  // Create a variable that is a collection of results that are Item objects
  var todoItems : Results<Item>?

  var selectedCategory : Category? {
    didSet {
      loadItems()
      
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
  }
  
  
  //MARK: - Tableview Datasource Methods
  
  //TODO: Declare numberOfRowsInSection here:
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoItems?.count ?? 1
  }
  
  //TODO: Declare cellForRowAtIndexPath here:
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
    
    if let item = todoItems?[indexPath.row] {
      
      cell.textLabel?.text = item.title
      
      // Ternary operator ==>
      // value = condition ? valueIfTrue : valueIfFalse
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No Items Added"
      
    }
    
    return cell
  }
  
  
  //MARK: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = todoItems?[indexPath.row] {
      do {
        try realm.write {
          item.done = !item.done
        }
      } catch {
        print("Error saving done status, \(error)")
      }
    }
    
    // Call all the Tableview Datasource methods
    tableView.reloadData()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  
  //MARK: - Add New Item to the list
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button on our UIAlert
      
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date() // records current date/time when item is created
            currentCategory.items.append(newItem)
          }
        } catch {
          print("Error saving new items, \(error)")
        }
      }
      
      // Call all the Tableview Datasource methods
      self.tableView.reloadData()
      
    }
    
    // add a text field to the pop up alert
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  
  //MARK: - Model Manipulation Methods

  func loadItems() {
    
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    
    // Call all the Tableview Datasource methods
    tableView.reloadData()
  }
  
}


//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
    
    // Call all the Tableview Datasource methods
    tableView.reloadData()
    
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()

      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }

    }

  }

}
