import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    private let searchController = UISearchController()
    
    private let realm = try! Realm()

    private var items: Results<ToDoItem>?
    
    private var selectedCategory: ToDoCategory? {
        didSet {
            loadItemsFromRealm()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController

                print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        print(Date().timeIntervalSince1970.description)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            reusableCell.textLabel?.text = item.taskName
            reusableCell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            reusableCell.textLabel?.text = "No Tasks added yet"
        }
        
        return reusableCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try self.realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error with isDone property changing, \(error)")
            }
            
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - Public methods


extension TasksViewController {
    func setSelectedCategory(_ category: ToDoCategory?) {
        selectedCategory = category
    }
}


//MARK: - UISearchResultsUpdating


extension TasksViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if !text.isEmpty {
            loadItemsFromRealm()
            
            items = items?.filter("taskName CONTAINS[cd] %@", text).sorted(byKeyPath: "creationDate")
        } else {
            loadItemsFromRealm()
        }
        
        tableView.reloadData()
    }
}


//MARK: - UISearchBarDelegate


extension TasksViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
}


//MARK: - @IBActions


private extension TasksViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add new ToDo task", message: "", preferredStyle: .alert)
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Type your task"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add task", style: .default) { action in
            if let taskName = textField?.text,
               let safeSelectedCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newToDoItem = ToDoItem()
                        newToDoItem.taskName = taskName
                        newToDoItem.creationDate = Date()
                        safeSelectedCategory.items.append(newToDoItem)
                    }
                } catch {
                    print("Error with item saving, \(error)")
                }
                
                self.tableView.reloadData()
            }
        })
        
        present(alert, animated: true)
    }
}


//MARK: - Private methods


private extension TasksViewController {
    func loadItemsFromRealm() {
        items = selectedCategory?.items.sorted(byKeyPath: "creationDate")
    }
}


//MARK: - Set up methods


private extension TasksViewController {}
