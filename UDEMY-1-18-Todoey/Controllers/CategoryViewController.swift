//
//  CategoryViewController.swift
//  UDEMY-1-18-Todoey
//
//  Created by Destiny Sopha on 7/21/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
  
  //Initialize a new access point to the Realm database
  let realm = try! Realm()
  
  // Create a variable that is a collection of results that are Category objects
  var categories: Results<Category>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    //  This next line prints the location of the Realm database when un-commented out
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    loadCategories()
    
    tableView.separatorStyle = .none
    
  }
  
  
  //Mark: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    // Return the number of Caterories as the NumberOfRowsInSection, if there are none, it returns 1
    return categories?.count ?? 1
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    if let category = categories?[indexPath.row] {
      
      cell.textLabel?.text = category.name ?? "No categories added yet"
      
      // Then save the color as a UIColor.
      cell.backgroundColor = UIColor(hexString: category.cellBGColor ?? "1D9BF6")

    }
    
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
    
    // Then save the color as a UIColor.
    // cell.backgroundColor = UIColor(hexstring: cellBGColor)
    cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].cellBGColor ?? "1D9BF6")
    cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true) // sets text to contrast the background color

    return cell
    
  }
  
  //Mark: - TableView Delegate Methods
  
  // This code will launch the goToItems segue
  // The segue will open the related ToDo items list when a Category is chosen
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

  
  //MARK: Delete Data From Swipe
  
  override func updateModel(at indexPath: IndexPath) {
    
    if let categoryForDeletion = self.categories?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(categoryForDeletion)
        }
      } catch {
        print("Error deleting category, \(error)")
      }
    }
  }

  
  //Mark: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      // what will happen when the user clicks the Add Category button on our UIAlert
      
      let newCategory = Category()
      newCategory.name = textField.text!
      newCategory.cellBGColor = UIColor.randomFlat.hexValue()
      
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

