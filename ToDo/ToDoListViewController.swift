import UIKit

class ToDoListViewController: UITableViewController {
    var items = ["Buy milk", "Do my homework", "Pet my cat"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
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

            self?.items.append(text)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
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

