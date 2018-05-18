//
//  ViewController.swift
//  Todoey
//
//  Created by Xavier Davis on 5/18/18.
//  Copyright © 2018 Xavier Davis. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let itemArray = ["kdjkdj", "kjdhkjdlkjoijmnw", "kjdojsnkjnwindopl"]

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

}

