import Foundation

struct ToDoItem: Codable {
    let taskName: String
    var isDone: Bool = false
}
