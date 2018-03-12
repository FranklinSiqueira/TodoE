//
//  ViewController.swift
//  TodoE
//
//  Created by Franklin Siqueira on 09/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Begining with ViewController definition

class ToDoListViewController: UITableViewController {

    // Defining data paths
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    // Creating an array of objects of class item, defined in item.swift
    var itemArray = [Item]()
    
    // Default settings variable
    // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieving data into plist file (if it exists)
        // if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
        //    itemArray = items
        //}
        
        // Using newly defined hard coded data type item
//        let newItem = Item()
//        newItem.title = "Go to dentist"
//        itemArray.append(newItem)
        
        loadItems()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Delegating searchBar
        // searchBar.delegate = self
        
        
    }
    
    //@IBOutlet weak var searchBar: UISearchBar!
    
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
        
        // If one wants to phisically delete items from database. Order MATTERS!
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        tableView.deselectRow(at: indexPath, animated: true)
//        // Adding a check mark
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
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
            
            // What happens when user clicks "+" button
            self.itemArray.append(newItem)
            
            // Calling saveItems() to append data
            self.saveItems()
            
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
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
    
        }
        
        // Reloading UITableView data
        tableView.reloadData()
    }
    
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        // New on lecture 253, Section 19
        // let request : NSFetchRequest<Item> = Item.fetchRequest()
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
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] $@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

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







