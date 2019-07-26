//
//  CategoryViewController.swift
//  UDEMY-1-18-Todoey
//
//  Created by Destiny Sopha on 7/21/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
  
  var categoryListArray = [Category]()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
    loadCategories()
    
  }


  //Mark: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryListArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    cell.textLabel?.text = categoryListArray[indexPath.row].name
    
    
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
      destinationVC.selectedCategory = categoryListArray[indexPath.row]
    }
    
  }
  
  
  //Mark: - Data Manipulation Methods
  
  func saveCategories() {
    
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
    
    tableView.reloadData()
    
  }
  
  
  func loadCategories() {
    
    let request : NSFetchRequest<Category> = Category.fetchRequest()
    
    do {
      categoryListArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
    
    tableView.reloadData()
  }


  //Mark: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
      // what will happen when the user clicks the Add Category button on our UIAlert
      
      let newCategory = Category(context: self.context)
      newCategory.name = textField.text!
      
      self.categoryListArray.append(newCategory)
      
      self.saveCategories()
      
    }
    
    alert.addAction(action)
    
    alert.addTextField { (field) in
      textField = field
      textField.placeholder = "Add new category"
      
    }
    
    present(alert, animated: true, completion: nil)
    
  }
  
}
