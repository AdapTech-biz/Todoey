//
//  ViewController.swift
//  Todoey
//
//  Created by Xavier Davis on 5/18/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray  = [Item]()
    //creates a new plist to encode and decode customer data types
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    // context variable set to the context object inside AppDelegage -- uses Singleton to get AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        loadItems() //loads the saved items

        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let currentItem = itemArray[indexPath.row]
       
        cell.textLabel?.text = currentItem.text
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = currentItem.checked ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK - TableView Delegate Method
    ///////////////////////////////////////////////////////
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedItem = itemArray[indexPath.row]
        
        selectedItem.checked = !selectedItem.checked
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
    }
    
   override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        print("Row number \(indexPath.row) was deselected...")
    
    }
    
    /////////////////////////////////////////////////////
    
    //MARK - Add new items
    ////////////////////////////////////////////////////
    @IBAction func addButtonPressed(_ sender: Any) {
        
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        // what happends once the user clicks the add item alert action button
        let action = UIAlertAction(title: "Add Item", style: .default) {
            
            (action) in
            
            let newItem = Item(context: self.context)
            newItem.text = textField.text!
            newItem.checked = false
            
            self.itemArray.append(newItem)
            
           self.saveItems()
            
        }
        
        alert.addTextField {
            
            (alertTextField) in
            
            alertTextField.placeholder = "Add new item"
            textField = alertTextField  // stores a reference to the global textField object for global use in the alert action completion block
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //////////////////////////////////////////////////////
    
    //MARK - Model Manupulation Methods
    
    func saveItems(){
        //encodes custom class object type to store into plist file
        
        do{
           try self.context.save()

        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        // all fetches are NSFetchRequest object and you have to explictly tell the object type of the fetched data
        let request : NSFetchRequest<Item>  = Item.fetchRequest()   //creates a fetch request from the Item object
        do{
          itemArray =  try context.fetch(request)   //sends the fetch request to the context to get the data from DB
        } catch {
            print("Error fetching items \(error)")
        }
    }
    

}

