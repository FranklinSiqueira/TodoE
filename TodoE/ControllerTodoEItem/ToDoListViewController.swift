//
//  ViewController.swift
//  TodoE
//
//  Created by Franklin Siqueira on 09/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    // Defining data paths
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // Creating an array of objects of class item, defined in item.swift
    var itemArray = [Item]()
    
    // Default settings variable
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieving data into plist file (if it exists)
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
        
        // Using newly defined hard coded data type item
//        let newItem = Item()
//        newItem.title = "Go to dentist"
//        itemArray.append(newItem)
        
        loadItems()
        
    }
    
    //MARK - TableView DataSource Methods
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
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
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
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add nem Event", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            // Using with changes made in lecture 249, Section 19
            let newItem = Item()
            newItem.title = textField.text!
            
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
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)!")
        }
        
        // Reloading UITableView data
        tableView.reloadData()
    }
    
    func loadItems () {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                
            }
        }
    }
    
    
}







