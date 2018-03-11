//
//  ViewController.swift
//  TodoE
//
//  Created by Franklin Siqueira on 09/03/18.
//  Copyright © 2018 Franklin Siqueira. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Todo One", "Todo Two", "Todo Three"]
    // Default settings variable
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.stringArray(forKey: "ToDoListArray"){
            itemArray = items
        }
    }
    
    //MARK - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        // Adding a check mark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    // MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add nem Event", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            // What happens when user clicks "+" button
            self.itemArray.append(textField.text!)
            // Reloading UITableView data
            self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Insert New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        // Presente it to screen
        present(alert, animated: true, completion: nil)
    }
    
    
}







