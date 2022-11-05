import UIKit

class ToDoListViewController: UITableViewController {
    let itemArray = ["QQQ", "WWW", "EEE", "RRR", "TTT", "YYY"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
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
        
        let action = UIAlertAction(title: "Add task", style: .default) {action in
            print("add button was selected")
            
            guard let text = textField?.text else { return }
            
            print(text)
        }
        
        alert.addAction(action) 
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Type your task"
            textField = alertTextField
        }
        
        present(alert, animated: true)
    }
}


//MARK: - Private methods


private extension ToDoListViewController {
    
}


//MARK: - Set up methods


private extension ToDoListViewController {
    
}

