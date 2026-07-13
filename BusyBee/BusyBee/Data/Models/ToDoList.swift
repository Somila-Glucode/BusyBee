import Foundation
import SwiftData

@Model
class ToDoList
{
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    @Relationship(deleteRule:.cascade)var items: [ToDoItem] = []
    
    init(name: String)
    {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}
