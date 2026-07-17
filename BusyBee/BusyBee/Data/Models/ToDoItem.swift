import Foundation
import SwiftData

@Model
class ToDoItem
{
    @Attribute(.unique) var id: UUID
    var name: String
    var dueDate : Date
    var isCompleted: Bool
    var createdAt: Date
    
    var list: ToDoList?
    
    init(name: String, dueDate: Date, isCompleted: Bool)
    {
        self.id = UUID()
        self.name = name
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.createdAt = Date()
    }
}
