import Foundation
import RealmSwift

class ToDoCategory: Object {
    @objc dynamic var name: String = ""
    let items = List<ToDoTask>()
}
