//
//  CategoryViewController.swift
//  TodoE
//
//  Created by Franklin Siqueira on 12/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import UIKit
// import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<CategoryTb>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Creating an array of objects of class Category, defined in item.swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    func loadCategories (){
        
        categoryArray = realm.objects(CategoryTb.self)
        
        tableView.reloadData()
        
        // Below, using Core Data
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error loading Categories: \(error)")
//        }
//

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Using the nil coalescing operator "??"
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].category ?? "No Categories Added..."
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldCategory = UITextField()
        
        let alertCategory = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let actionCategory = UIAlertAction(title: "Add!", style: .default) {(action) in
            
            // Using with changes made in lecture 249, Section 19
            let newCategory = CategoryTb()
         
            newCategory.category = textFieldCategory.text!
            //newCategory.done = false
            
            // What happens when user clicks "+" button
            // self.categoryArray.append(newCategory)
            
            // Calling saveCategory() to append data
            self.save(category: newCategory)
            
        }
        alertCategory.addTextField { (alertTextField) in
            alertTextField.placeholder = "Insert New Category"
            textFieldCategory = alertTextField
        }
        alertCategory.addAction(actionCategory)
        // Present it to screen
        present(alertCategory, animated: true, completion: nil)
    }

    // MARK: - Table view data source methods / TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        //print(categoryArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation
    
    // Method
    func save(category: CategoryTb){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving new Category: \(error)")
        }
        tableView.reloadData()
    }

}
