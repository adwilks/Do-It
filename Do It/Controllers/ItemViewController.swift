//
//  ViewController.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/15/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemViewController: SwipeTableViewController{
    // View Properties
    @IBOutlet weak var searchBar: UISearchBar!
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatGray()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let colorHex = selectedCategory?.cellColor else {fatalError()}
        updateNavBar(withHexCode: colorHex)
    }
    
    // Mark - TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // Use parent category color to create the gradient flow for items
            if let color = UIColor(hexString: selectedCategory?.cellColor).darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) / 3.0) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
            
            // Draw checkmark on row based on isDone state
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no items added"
        }
        return cell
    }
    
    //Mark - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        // Switch checkmark on/off on selected row
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                    print("error updating selected item: \(error)")
                }
            }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark - Add New Item button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newItemText = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Handle item action
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = newItemText.text!
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items, \(error)")
                }

            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item..."
            newItemText = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems () {
        // Allows for multiple query types: one for item, one for category (DEFAULT)
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    //MARK: Delete Data
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = toDoItems?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: Update Nav Bar
    func updateNavBar(withHexCode colorHex: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError()}
        guard let navBarColor = UIColor(hexString: colorHex) else {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn: navBarColor, isFlat: true)!]
        searchBar.barTintColor = navBarColor
    }
}

// Mark - Search Bar Delegate Methods
extension ItemViewController: UISearchBarDelegate {
    // Query the realm database for the searched for item(s)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    // When the search bar is dismissed reload the full set of items
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            tableView.reloadData()
        }
    }

    }

