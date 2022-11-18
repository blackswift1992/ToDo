//
//  Constants.swift
//  ToDo
//
//  Created by Олексій Мороз on 18.11.2022.
//  Copyright © 2022 Oleksii Moroz. All rights reserved.
//

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
        }
        
        struct Task {
            static let creationDate = "creationDate"
        }
    }
}
