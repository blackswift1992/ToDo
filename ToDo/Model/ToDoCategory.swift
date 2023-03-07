import Foundation
import RealmSwift

class ToDoCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColorHexValue: String = ""
    let tasks = List<ToDoTask>()
}
