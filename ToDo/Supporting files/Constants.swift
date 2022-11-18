import Foundation

struct K {
    struct Segue {
        static let goToTasks = "GoToTasks"
    }
    
    struct TableView {
        static let categoryCellId = "ToDoCategoryCell"
        static let taskCellId = "ToDoTaskCell"
    }
    
    struct RealmDb {
        static let searchByNamePredicate = "name CONTAINS[cd] %@"
        
        struct Category {
            static let name = "name"
            static let tasks = "tasks"
        }
        
        struct Task {
            static let creationDate = "creationDate"
        }
    }
}
