import UIKit

class ToDoListViewController: UITableViewController {
    private var toDoListItems = [ToDoItem]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("ToDoItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadToDoItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoListItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let toDoItem = toDoListItems[indexPath.row]
        
        cell.textLabel?.text = toDoItem.taskName
        
        cell.accessoryType = toDoItem.isDone ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoListItems[indexPath.row].isDone = !(toDoListItems[indexPath.row].isDone)
        
        saveToDoItems()
        
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
            
            self?.toDoListItems.append(ToDoItem(taskName: text))
            
            self?.saveToDoItems()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}


//MARK: - Private methods


private extension ToDoListViewController {
    func saveToDoItems() {
        guard let safeDataFilePath = dataFilePath else { return }
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(toDoListItems)
            try data.write(to: safeDataFilePath)
        } catch {
            print("Error with toDoListItems array encoding \(error)")
        }
        
        tableView.reloadData()
    }
}


//MARK: - Set up methods


private extension ToDoListViewController {
    func loadToDoItems() {
        guard let safeDataFilePath = dataFilePath else { return }
        
        do {
            let data = try Data(contentsOf: safeDataFilePath)
            
            let decoder = PropertyListDecoder()
            
            toDoListItems = try decoder.decode([ToDoItem].self, from: data)
            
        } catch {
            print("Decoding data was failed, \(error)")
        }
    }
}

