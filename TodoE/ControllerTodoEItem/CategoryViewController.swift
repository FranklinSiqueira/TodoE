//
//  CategoryViewController.swift
//  TodoE
//
//  Created by Franklin Siqueira on 12/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Creating an array of objects of class Category, defined in item.swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    func loadCategories (){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading Categories: \(error)")
        }
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldCategory = UITextField()
        
        let alertCategory = UIAlertController(title: "Add New Categoty", message: "", preferredStyle: .alert)
        
        let actionCategory = UIAlertAction(title: "Add!", style: .default) {(action) in
            
            // Using with changes made in lecture 249, Section 19
            let newCategory = Category(context: self.context)
            newCategory.name = textFieldCategory.text!
            //newCategory.done = false
            
            // What happens when user clicks "+" button
            self.categoryArray.append(newCategory)
            
            // Calling saveCategory() to append data
            self.saveCategory()
            
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
        print(categoryArray[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation
    
    // Method
    func saveCategory (){
        do {
            try context.save()
        } catch {
            print("Error saving new Category: \(error)")
        }
        tableView.reloadData()
    }

}
