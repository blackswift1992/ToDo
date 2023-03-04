import UIKit
import RealmSwift

class CategoriesViewController: SwipeTableViewController {
    private let searchController = UISearchController()
    
    private let realm = try! Realm()
    
    private var categories: Results<ToDoCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchController()
        loadCategoriesFromRealm()
    }
    
    
    //MARK: -- TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categories?[indexPath.row]
        reusableCell.textLabel?.text = category?.name ?? "No Categories added yet"
        
        return reusableCell
    }
    
    
    //MARK: -- TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories != nil {
            performSegue(withIdentifier: K.Segue.goToTasks, sender: self)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: -- SwipeCellUpdateMethod
    
    
    override func updateModel(at indexPath: IndexPath) {
        guard let selectedCategory = categories?[indexPath.row] else { return }
        
        deleteCategoryFromRealm(selectedCategory)
    }
    
    
    //MARK: -- prepare for segue
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TasksViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.setSelectedCategory(categories?[indexPath.row])
        }
    }
}


//MARK: - Public methods


extension CategoriesViewController {}


//MARK: - UISearchResultsUpdating


extension CategoriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if !text.isEmpty {
            loadCategoriesFromRealm()
            
            categories = categories?.filter(K.RealmDb.searchByNamePredicate, text).sorted(byKeyPath: K.RealmDb.Category.name)
        } else {
            loadCategoriesFromRealm()
        }
        
//        tableView.reloadData()   ??????може все тики треба для першого іфа
    }
}


//MARK: - UISearchBarDelegate


extension CategoriesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {}
}



//MARK: - @IBActions


private extension CategoriesViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Type category name"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add category", style: .default) { _ in
            guard let name = textField?.text else { return }
            
            let newCategory = ToDoCategory()
            newCategory.name = name

            self.saveCategoryToRealm(newCategory)
            self.tableView.reloadData()
        })
        
        present(alert, animated: true)
    }
}


//MARK: - Private methods


private extension CategoriesViewController {
    func loadCategoriesFromRealm() {
        categories = realm.objects(ToDoCategory.self)
        tableView.reloadData()
    }
    
    
    func saveCategoryToRealm(_ category: ToDoCategory) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error with category saving, \(error)")
        }
    }
    
    
    func deleteCategoryFromRealm(_ category: ToDoCategory) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error with category saving, \(error)")
        }
    }
}


//MARK: - Set up methods


private extension CategoriesViewController {
    func setUpSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
    }
}


