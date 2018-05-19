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
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    var itemArray  = [Item]()
    //creates a new plist to encode and decode customer data types
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    // context variable set to the context object inside AppDelegage -- uses Singleton to get AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        
    }

    func tableviewTapped(){
        
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

    //MARK: - TableView Delegate Method
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
    
    //MARK: - Add new items
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
            newItem.parentCategory = self.selectedCategory  //sets the relation category of the new task
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
    
    //MARK: - Model Manupulation Methods
    
    func saveItems(){
        //encodes custom class object type to store into plist file
        
        do{
           try self.context.save()

        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        // all fetches are NSFetchRequest object and you have to explictly tell the object type of the fetched data
    
        //this perdicate to happen no matter what -- but also welcome new perdicates
        let categoryPerdicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addditionalPredicate = predicate {   //optional unwrapping to check if an additional perdicate was passed
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPerdicate, addditionalPredicate])
        }else{
            request.predicate = categoryPerdicate
        }
       
        do{
          itemArray =  try context.fetch(request)   //sends the fetch request to the context to get the data from DB
        } catch {
            print("Error fetching items \(error)")
        }
        
        tableView.reloadData()
        
    }
    

    

}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //visit https://static.realm.io/downloads/files/NSPredicateCheatsheet.pdf?_ga=2.108278466.1313774674.1526763649-148550912.1526763649  to understand NSPredicate queries
        request.predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
        
         request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        
        loadItems(with: request, predicate: request.predicate)

    }
    
    //Resets the list to the original state
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 { // a blank text field
            loadItems()
            
            //DispatchQueue manages the event threads -- dismisses the keyboard and cursor in the search bar in the foreground
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    

    
    
}
