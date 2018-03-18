//
//  ToDoViewController.swift
//  TodoE
//
//  Created by Franklin Siqueira on 09/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

//MARK: - Begining with ViewController definition

class ToDoListViewController: UITableViewController {

//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Creating an array of objects of class item, defined in item.swift
    
    let realm = try! Realm()
    
    // Core Data declaration -> var itemArray = [Item]()
    
    // Using Realm
    var itemArray: Results<ItemTb>?
    
    var selectedCategory : CategoryTb? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        navigationItem.title = selectedCategory?.category
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
        
        // Using Ternary operator : value = condition ? valueIfTrue : ValueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added in selected Category..."
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating status \(error)")
            }
        }
        
//        print(itemArray[indexPath.row])
    
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    // MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add nem Event", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
        // Using Realm
        if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                let newItem = ItemTb()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
                }
            } catch {
                print("Error saving new item, \(error)")
            }

            }
            self.tableView.reloadData()
        }
        
        // Using Core Data
//        var textField = UITextField()
//        
//        let alert = UIAlertController(title: "Add nem Event", message: "", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
//            
//            // Using with changes made in lecture 249, Section 19
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.itemToCategory = self.selectedCategory
//            
//            // What happens when user clicks "+" button
//            self.itemArray.append(newItem)
//            
//            // Calling saveItems() to append data
//            self.saveItems()
//            
//            }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Insert New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        // Present it to screen
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Manipulating data in the database level
    func loadItems(){
        // Using Realm
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    func saveItems () {
//        // let encoder = PropertyListEncoder() deleted after lecture 250, section 19
//
//        do {
//            try context.save()
//        } catch {
//            print("Error saving Item: \(error)")
//        }
//
//        // Reloading UITableView data
//        tableView.reloadData()
    }
    
    
    
//    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        // New on lecture 253, Section 19
//        // let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let categoryPredicate = NSPredicate(format: "itemToCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context! \(error)")
//        }
//    }
}

//MARK: - Search database

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
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







