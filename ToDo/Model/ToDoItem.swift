import Foundation

struct ToDoItem: Encodable {
    let taskName: String
    var isDone: Bool = false
}
