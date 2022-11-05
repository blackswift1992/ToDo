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
        var cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
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
    
}


//MARK: - Private methods


private extension ToDoListViewController {
    
}


//MARK: - Set up methods


private extension ToDoListViewController {
    
}

