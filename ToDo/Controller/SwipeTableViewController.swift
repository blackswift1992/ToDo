import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        
    }
    
    
    //MARK: -- TableView Datasource Methods
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: K.TableView.cellId, for: indexPath) as! SwipeTableViewCell
        
        reusableCell.delegate = self
        
        return reusableCell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let editAction = SwipeAction(style: .default, title: "Edit") { [weak self] action, indexPath in
            self?.editCell(at: indexPath)
        }
        editAction.backgroundColor = .flatYellowDark()
        editAction.image = UIImage(named: "edit-icon")
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            self?.deleteCell(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction, editAction]
    }
    
    
    //MARK: -- SwipeTableViewCellDelegate
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteCell(at indexPath: IndexPath) {
        //Update here your data model
        //Or you can override this method in a subclass and put here realization of data model changing
    }
    
    func editCell(at indexPath: IndexPath) {
        //Update here your data model
        //Or you can override this method in a subclass and put here realization of data model changing
    }
}


//MARK: - Set up methods


private extension SwipeTableViewController {
    func setUpTableView() {
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
}
