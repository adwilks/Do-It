//
//  ViewController.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/15/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import UIKit

class DoItViewController: UITableViewController {

    // Mark - TableView Datasource methods
    var tableArray = ["Learn Karate", "Master art", "Defeat Sensei", "Become the master"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let table = defaults.array(forKey: "ToDoListArray") as? [String] {
            tableArray = table
        }
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
    
    //Mark - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO Write method for what to do on row selection
       
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Mark - Add New Item button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemText = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Handle item action
            self.tableArray.append(newItemText.text!)
            self.defaults.setValue(self.tableArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item..."
            newItemText = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

