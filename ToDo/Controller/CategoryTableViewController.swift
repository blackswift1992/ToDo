//
//  CategoryTableViewController.swift
//  ToDo
//
//  Created by Олексій Мороз on 11.11.2022.
//  Copyright © 2022 Oleksii Moroz. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    private let searchController = UISearchController()
    
    private let realm = try! Realm()
    
    var categories: Results<ToDoCategory>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        
        loadCategoriesFromRealm()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        let category = categories?[indexPath.row]
        
        reusableCell.textLabel?.text = category?.name ?? "No Categories added yet"
        
        return reusableCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if categories != nil {
            performSegue(withIdentifier: "goToToDoItems", sender: self)
        }

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ToDoListViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.setSelectedCategory(categories?[indexPath.row])
        }
    }
}


//MARK: - Public methods


extension CategoryTableViewController {
    
}


//MARK: - UISearchResultsUpdating


extension CategoryTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
        
//        if !text.isEmpty {
//            let request: NSFetchRequest<ToDoCategory> = ToDoCategory.fetchRequest()
//
//            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
//
//            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//            loadCategoriesFromDb(with: request)
//        } else {
//            loadCategoriesFromDb()
//        }
        
        tableView.reloadData()
    }
}


//MARK: - UISearchBarDelegate


extension CategoryTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        loadToDoItemsFromDb()   //не працює так як після цього визову відбувається ще декілька викликів метода updateSearchResults()
    }
}


//MARK: - @IBActions


private extension CategoryTableViewController {
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField?
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField() { alertTextField in
            alertTextField.placeholder = "Type category name"
            textField = alertTextField
        }
        
        alert.addAction(UIAlertAction(title: "Add category", style: .default) { [weak self] action in
            guard let name = textField?.text else { return }
            
            let newCategory = ToDoCategory()
            newCategory.name = name

            self?.saveCategoryToRealm(newCategory)
            self?.tableView.reloadData()
        })
        
        present(alert, animated: true)
    }
}


//MARK: - Private methods


private extension CategoryTableViewController {
    func loadCategoriesFromRealm() {
        categories = realm.objects(ToDoCategory.self)
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
}


//MARK: - Set up methods


private extension CategoryTableViewController {
    
}

