//
//  CategoryViewController.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/16/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{

    // MARK: - View Properties
    var categoryArray: Results<Category>?
    let realm = try! Realm()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].cellColor)
        
        return cell
    }
    // MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Load child item list on selection
        
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    // MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCatText = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCat = Category()
            newCat.name = newCatText.text!
            newCat.cellColor = UIColor.randomFlat()?.hexValue()
            self.save(category: newCat)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category..."
            newCatText = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Context: \(error)")
        }
    }
    
    func loadCategories () {
        
       categoryArray = realm.objects(Category.self)
    
    }
    // MARK: Delete Data
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error Deleting category: \(error)")
            }
        }
    }
}


