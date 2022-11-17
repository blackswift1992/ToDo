import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    private let searchController = UISearchController()
    
    private let realm = try! Realm()

    private var items: Results<ToDoItem>?
    
    private var selectedCategory: ToDoCategory? {
        didSet {
            loadItemsFromRealm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController

        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        
//        safeItems[indexPath.row].isDone = !(safeItems[indexPath.row].isDone)
//
//
//                saveItemToRealm()
//        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - Public methods


extension ToDoListViewController {
    func setSelectedCategory(_ category: ToDoCategory?) {
        selectedCategory = category
    }
}


//MARK: - UISearchResultsUpdating


extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//
//        if !text.isEmpty {
//            let request: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
//
//            let predicate = NSPredicate(format: "taskName CONTAINS[cd] %@", text)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "taskName", ascending: true)]
//
//            loadToDoItemsFromDb(with: request, additionalPredicate: predicate)
//        } else {
//            loadToDoItemsFromDb()
//        }
//
//        tableView.reloadData()
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


private extension ToDoListViewController {
    func loadItemsFromRealm() {
        items = selectedCategory?.items.sorted(byKeyPath: "taskName")
    }

//    func saveItemToRealm(_ item: ToDoItem) {
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("Error with item saving, \(error)")
//        }
//    }
}


//MARK: - Set up methods


private extension ToDoListViewController {
    
    
}

