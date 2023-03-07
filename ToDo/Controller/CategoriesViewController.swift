import UIKit
import RealmSwift
import ChameleonFramework

class CategoriesViewController: SwipeTableViewController {
    private let searchController = UISearchController()
    
    private let realm = try! Realm()
    
    private var categories: Results<ToDoCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        setUpSearchController()
        loadCategoriesFromRealm()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: [.flatMintDark(), .flatPurpleDark(), .flatBlackDark()])
        
        if let navigationBar = navigationController?.navigationBar {
                navigationBar.backgroundColor = .flatMintDark()
        }
    }
    
    
    //MARK: -- TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categories?[indexPath.row]
        reusableCell.textLabel?.text = category?.name ?? "No Categories added yet"
        reusableCell.textLabel?.font = UIFont(name: "Pacifico", size: 30.0)
        reusableCell.backgroundColor = UIColor(hexString: category?.backgroundColorHexValue ?? "#000000")
        
        if let color = UIColor(hexString: category?.backgroundColorHexValue ?? "#000000") {
            reusableCell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)

        }

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
    
    
    override func deleteCell(at indexPath: IndexPath) {
        guard let selectedCategory = categories?[indexPath.row] else { return }
        
        deleteCategoryFromRealm(selectedCategory)
    }
    
    
    override func editCell(at indexPath: IndexPath) {
        guard let selectedCategory = categories?[indexPath.row] else { return }
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Type new name", message: "", preferredStyle: .alert)
        
        alert.addTextField() { alertTextField in
            alertTextField.text = "\(selectedCategory.name)"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] action in
            if let newName = textField?.text {
                self?.editCategoryInRealm(selectedCategory, newName: newName)
                self?.tableView.reloadData()
            }
        })
        
        present(alert, animated: true)
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


extension CategoriesViewController: UISearchBarDelegate  {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {}
}



//MARK: - @IBActions


private extension CategoriesViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Type category name"
            alertTextField.autocapitalizationType = .sentences
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Add category", style: .default) { _ in
            guard let name = textField?.text else { return }
            
            let newCategory = ToDoCategory()
            newCategory.name = name
            newCategory.backgroundColorHexValue = UIColor.randomFlat().hexValue()
            
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
    
    func editCategoryInRealm(_ category: ToDoCategory, newName: String) {
        do {
            try realm.write {
                category.name = newName
            }
        } catch {
            print("Error with task editing, \(error)")
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


