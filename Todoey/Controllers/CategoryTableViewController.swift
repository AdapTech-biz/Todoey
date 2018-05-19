//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Xavier Davis on 5/19/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

 
    }



    //MARK: - Add Category Button Press
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var textField : UITextField?
        
        let alert = UIAlertController(title: "New Category", message: "Add new task category?", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category..."
            textField = alertTextField
        }
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            //add new category to db
            let newCategory = Category(context: self.context)
            newCategory.name = textField?.text!
            self.categoryArray.append(newCategory)
            self.saveContext()
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    /////////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            let index = indexPath
            let selectedCategory = categoryArray[index.row]
            destination.selectedCategory = selectedCategory
        }
        
    }

    //////////////////////////////////////////////
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveContext(){
        do{
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryArray = try context.fetch(request)

        }catch {
            print("Error loading categories \(error)")
        }
    }
    //////////////////////////////////////////////////
    
}
