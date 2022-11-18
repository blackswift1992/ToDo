import Foundation
import RealmSwift

class ToDoTask: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var creationDate: Date?
    var parentCategory = LinkingObjects(fromType: ToDoCategory.self, property: "items")
}
