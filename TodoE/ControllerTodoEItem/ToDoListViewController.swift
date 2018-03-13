//
//  ToDoViewController.swift
//  TodoE
//
//  Created by Franklin Siqueira on 09/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Begining with ViewController definition

class ToDoListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Creating an array of objects of class item, defined in item.swift
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Using Ternary operator : value = condition ? valueIfTrue : ValueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
    
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add nem Event", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            
            // Using with changes made in lecture 249, Section 19
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.itemToCategory = self.selectedCategory
            
            // What happens when user clicks "+" button
            self.itemArray.append(newItem)
            
            // Calling saveItems() to append data
            self.saveItems()
            
            }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Insert New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        // Present it to screen
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Manipulating data in the database level
    
    func saveItems () {
        // let encoder = PropertyListEncoder() deleted after lecture 250, section 19
        
        do {
            try context.save()
        } catch {
            print("Error saving Item: \(error)")
        }
        
        // Reloading UITableView data
        tableView.reloadData()
    }
    
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // New on lecture 253, Section 19
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "itemToCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context! \(error)")
        }
    }
}

//MARK: - Search database

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // Send the focus to the main controller
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
    }
}







