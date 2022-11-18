import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    private let searchController = UISearchController()
    
    private let realm = try! Realm()

    private var tasks: Results<ToDoTask>?
    
    private var selectedCategory: ToDoCategory? {
        didSet {
            loadTasksFromRealm()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
    }
    
    
    //MARK: -- TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: K.TableView.taskCellId, for: indexPath)
        
        if let task = tasks?[indexPath.row] {
            reusableCell.textLabel?.text = task.name
            reusableCell.accessoryType = task.isDone ? .checkmark : .none
        } else {
            reusableCell.textLabel?.text = "No Tasks added yet"
        }
        
        return reusableCell
    }
    
    
    //MARK: -- TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = tasks?[indexPath.row] {
            do {
                try self.realm.write {
                    task.isDone = !task.isDone
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
            loadTasksFromRealm()
            
            tasks = tasks?.filter(K.RealmDb.searchByNamePredicate, text).sorted(byKeyPath: K.RealmDb.Task.creationDate)
        } else {
            loadTasksFromRealm()
        }
        
        tableView.reloadData()
    }
}


//MARK: - UISearchBarDelegate


extension TasksViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {}
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
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add task", style: .default) { action in
            if let taskName = textField?.text,
               let safeSelectedCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newTask = ToDoTask()
                        newTask.name = taskName
                        newTask.creationDate = Date()
                        safeSelectedCategory.tasks.append(newTask)
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
    func loadTasksFromRealm() {
        tasks = selectedCategory?.tasks.sorted(byKeyPath: K.RealmDb.Task.creationDate)
    }
}


//MARK: - Set up methods


private extension TasksViewController {
    func setUpSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
    }
}

