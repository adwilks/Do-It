//
//  ViewController.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/15/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import UIKit
import CoreData

class DoItViewController: UITableViewController{

    // View Properties
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Mark - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        self.saveItems()
        // Draw checkmark on row based on isDone state
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
    }
    
    //Mark - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        // Switch checkmark on/off on selected row
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark - Add New Item button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemText = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Handle item action
            
            let newItem = Item(context: self.context)
            newItem.title = newItemText.text
            newItem.isDone = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item..."
            newItemText = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error Saving Context: \(error)")
        }
    }
    
    func loadItems (with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // Allows for multiple query types: one for item, one for category (DEFAULT)
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
    
}

// Mark - Search Bar Delegate Methods
extension DoItViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
