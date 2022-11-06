import UIKit

class ToDoListViewController: UITableViewController {
    private var toDoListItems = ["Buy milk", "Do my homework", "Pet my cat"]
    private let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let defaultsToDoListItems = defaults.object(forKey: "toDoListItems") as? [String] {
            toDoListItems = defaultsToDoListItems
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = toDoListItems[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}


//MARK: - Public methods


extension ToDoListViewController {
    
}


//MARK: - Protocols





//MARK: - @IBActions


private extension ToDoListViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle: .alert)
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Type your task"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add task", style: .default) { [weak self] action in
            guard let text = textField?.text else { return }
            
            self?.toDoListItems.append(text)
            self?.defaults.set(self?.toDoListItems, forKey: "toDoListItems")
            self?.tableView.reloadData()
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}


//MARK: - Private methods


private extension ToDoListViewController {
    
}


//MARK: - Set up methods


private extension ToDoListViewController {
    
}

