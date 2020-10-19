//
//  ToDoListViewController.swift
//  ToDoey
//
//  Created by Abdelrahman Shehab on 26/9/2020.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var toDoItems = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    /// Saving Data in User Defaults
    //let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
            loadData()
    }

    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = toDoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    // MARK: - Table View Delegate Methodes

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done

        saveData()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - IBOutlets
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {

        var toDoTextItemField = UITextField()

        let alert = UIAlertController(title: "Add ToDo Item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (alertAction) in

            let newItem = Item(context: self.context)
            newItem.title = toDoTextItemField.text!
            newItem.done = false
            self.toDoItems.append(newItem)

            self.saveData()

            /// Saving Data in User Defaults
            //            self.defaults.set(self.toDoItems, forKey: "ToDoListItems")
        }

        alert.addTextField { (alerttextField) in

            alerttextField.placeholder = "Create New Item"
            toDoTextItemField = alerttextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Model Manupulation Methods
    
        func loadData() {
    
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            do {
                toDoItems = try context.fetch(request)
            } catch  {
                print("Error in Fetching data \(error)")
            }
        }
    
    func saveData() {

        do {
            try context.save()
        } catch {
            print("Error Encoding Item Array \(error)")
        }

        self.tableView.reloadData()
    }
}


