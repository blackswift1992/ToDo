import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var taskName: String = ""
    @objc dynamic var isDone: Bool = false
    var parentCategory = LinkingObjects(fromType: ToDoCategory.self, property: "items")
}
