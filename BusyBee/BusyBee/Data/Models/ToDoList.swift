import Foundation
import SwiftData

@Model
class ToDoList
{
    @Attribute(.unique) var id: UUID
    var name: String
    var listDescription: String
    var icon: String
    var createdAt: Date
    @Relationship(deleteRule:.cascade) var items: [ToDoItem] = []
    
    init(name: String, listDescription: String, icon: String, items: [ToDoItem] = [])
    {
        self.id = UUID()
        self.name = name
        self.listDescription = listDescription
        self.icon = icon
        self.createdAt = Date()
        self.items = items
    }
}
