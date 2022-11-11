import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    private let searchController = UISearchController()
    
    private var toDoItemsArray = [ToDoItem]()
    private let dbContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        
        loadToDoItemsFromDb()
        
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let toDoItem = toDoItemsArray[indexPath.row]
        
        reusableCell.textLabel?.text = toDoItem.taskName
        reusableCell.accessoryType = toDoItem.isDone ? .checkmark : .none
        
        return reusableCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoItemsArray[indexPath.row].isDone = !(toDoItemsArray[indexPath.row].isDone)
        
        saveChangesToDb()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - Public methods


extension ToDoListViewController {
    
}


//MARK: - UISearchResultsUpdating


extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
        
        if !text.isEmpty {
            
            let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
            
            request.predicate = NSPredicate(format: "taskName CONTAINS[cd] %@", text)
            
            request.sortDescriptors = [NSSortDescriptor(key: "taskName", ascending: true)]
            
            loadToDoItemsFromDb(with: request)
            tableView.reloadData()
        } else {
            loadToDoItemsFromDb()
            tableView.reloadData()
        }
    }
}


//MARK: - UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        loadToDoItemsFromDb()   //не працює так як після цього визову відбувається ще декілька викликів метода updateSearchResults()
    }
}


//MARK: - @IBActions


private extension ToDoListViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle: .alert)
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Type your task"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add task", style: .default) { [weak self] action in
            guard let taskName = textField?.text,
                  let safeDbContext = self?.dbContext
            else { return }
            
            let newToDoItem = ToDoItem(context: safeDbContext)
            newToDoItem.taskName = taskName
            newToDoItem.isDone = false
            
            self?.toDoItemsArray.append(newToDoItem)
            self?.saveChangesToDb()
            self?.tableView.reloadData()
        })
        
        present(alert, animated: true)
    }
}


//MARK: - Private methods


private extension ToDoListViewController {
    func loadToDoItemsFromDb(with request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()) {

        do {
            if let fetchedToDoItems = try dbContext?.fetch(request) {
                toDoItemsArray = fetchedToDoItems
            }
        } catch {
            print("Fetching data from context was failed, \(error)")
        }
    }
    
    func saveChangesToDb() {
        guard let safeDbContext = dbContext else { return }
        
        do {
            try safeDbContext.save()
        } catch {
            print("Error with toDoItems saving, \(error)")
        }
    }
}


//MARK: - Set up methods


private extension ToDoListViewController {
    
}

