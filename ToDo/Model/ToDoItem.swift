import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var taskName: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var creationDate: Date?
    var parentCategory = LinkingObjects(fromType: ToDoCategory.self, property: "items")
}
