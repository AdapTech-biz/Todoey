//
//  ViewController.swift
//  Todoey
//
//  Created by Xavier Davis on 5/18/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["kdjkdj", "kjdhkjdlkjoijmnw", "kjdojsnkjnwindopl"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Current row number \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType != .checkmark {
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("Row number \(indexPath.row) was deselected...")
    }
    
    //MARK - Add new items
    ////////////////////////////////////////////////////
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what happends once the user clicks the add item alert action button
            
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField  // stores a reference to the global textField object for global use in the alert action completion block
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //////////////////////////////////////////////////////
    

}

