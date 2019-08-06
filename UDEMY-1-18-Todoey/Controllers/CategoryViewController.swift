//
//  CategoryViewController.swift
//  UDEMY-1-18-Todoey
//
//  Created by Destiny Sopha on 7/21/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
  
  //Initialize a new access point to the Realm database
  let realm = try! Realm()
  
  // Create a variable that is a collection of results that are Category objects
  var categories: Results<Category>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    loadCategories()
    
  }

  //Mark: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    // Return the number of Caterories as the Number or Rows, if there are none, it returns 1
    return categories?.count ?? 1

  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
    
    
    // let category = categoryListArray[indexPath.row]
    
    
    // Tenary operator ==>
    // value = condition ? valueIf True : valueIfFalse
    // this is not used right now (no done attribute in the Category table)
    // a done attribute would need to ba aded to the table
    
    // cell.accessoryType = Category.done ? .checkmark : .none
    
    return cell
    
  }


  //Mark: - TableView Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
  }
  
  override func prepare(for seque: UIStoryboardSegue, sender: Any?) {
    let destinationVC = seque.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
    
  }
  
  
  //Mark: - Data Manipulation Methods
  
  func save(category: Category) {
    
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving category \(error)")
    }
    
    // Call all the Tableview Datasource methods
    tableView.reloadData()
    
  }
  
  
  func loadCategories() {
    
    categories = realm.objects(Category.self)
    
    // Call all the Tableview Datasource methods
    tableView.reloadData()
    
  }


  //Mark: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      // what will happen when the user clicks the Add Category button on our UIAlert
      
      let newCategory = Category()
      newCategory.name = textField.text!

      self.save(category: newCategory)
      
    }
    
    alert.addAction(action)
    
    alert.addTextField { (field) in
      textField = field
      textField.placeholder = "Add new category"
      
    }
    
    present(alert, animated: true, completion: nil)
    
  }
  
}
