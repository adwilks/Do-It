//
//  CategoryViewController.swift
//  Do It
//
//  Created by Adrien Wilkins on 6/16/19.
//  Copyright © 2019 Ukiyo LLC. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    // MARK: - View Properties
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        self.saveCategories()
        
        return cell
    }
    // MARK: - Table view Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Load child item list on selection
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Data Manipulation Methods
    
    
    
    // MARK: Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var newCatText = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCat = Category(context: self.context)
            newCat.name = newCatText.text
            self.categoryArray.append(newCat)
            self.saveCategories()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category..."
            newCatText = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories() {
        
        
        do {
            try context.save()
        } catch {
            print("Error Saving Context: \(error)")
        }
    }
    
    func loadCategories (with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
    }
    
}
