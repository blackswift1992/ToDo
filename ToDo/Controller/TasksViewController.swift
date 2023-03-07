import UIKit
import RealmSwift
import ChameleonFramework

class TasksViewController: SwipeTableViewController {
    private let searchController = UISearchController()
    
    private let realm = try! Realm()

    private var tasks: Results<ToDoTask>?
    
    private var selectedCategory: ToDoCategory? {
        didSet {
            loadTasksFromRealm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        setUpSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationBar = navigationController?.navigationBar,
           let category = selectedCategory,
           let categoryColor = UIColor(hexString: category.backgroundColorHexValue) {
            navigationBar.backgroundColor = categoryColor
            title = category.name
            
            view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: [categoryColor, .flatPurpleDark(), .flatBlackDark()])
        }
    }
    
    
    //MARK: -- TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = super.tableView(tableView, cellForRowAt: indexPath)
        if let task = tasks?[indexPath.row],
           let category = selectedCategory,
           let categoryColor = UIColor(hexString:  category.backgroundColorHexValue) {
            
            reusableCell.textLabel?.text = task.name
            reusableCell.accessoryType = task.isDone ? .checkmark : .none
            reusableCell.textLabel?.font = UIFont(name: "Caveat", size: 30.0)
            if let categoryDarkedColor = categoryColor.darken(byPercentage: 0.70 * CGFloat(indexPath.row) / CGFloat(tasks!.count + 1)) {
                reusableCell.backgroundColor = categoryDarkedColor
                reusableCell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: categoryDarkedColor, isFlat: true)
            }
            
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
    
    
    //MARK: -- SwipeCellUpdateMethod
    
    
    override func deleteCell(at indexPath: IndexPath) {
        guard let selectedTask = tasks?[indexPath.row] else { return }
        
        deleteTaskFromRealm(selectedTask)
    }
    
    override func editCell(at indexPath: IndexPath) {
        guard let selectedTask = tasks?[indexPath.row] else { return }
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Type new name", message: "", preferredStyle: .alert)
        
        alert.addTextField() { alertTextField in
            alertTextField.text = "\(selectedTask.name)"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] action in
            if let newName = textField?.text {
                self?.editTaskInRealm(selectedTask, newName: newName)
                self?.tableView.reloadData()
            }
        })
        
        present(alert, animated: true)
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
            alertTextField.autocapitalizationType = .sentences
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
    
    func deleteTaskFromRealm(_ task: ToDoTask) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("Error with task deletion, \(error)")
        }
    }
    
    func editTaskInRealm(_ task: ToDoTask, newName: String) {
        do {
            try realm.write {
                task.name = newName
            }
        } catch {
            print("Error with task editing, \(error)")
        }
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

