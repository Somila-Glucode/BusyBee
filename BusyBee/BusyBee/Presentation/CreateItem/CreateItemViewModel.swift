import Foundation
import Combine
import SwiftUI


class ToDoListViewModel: ObservableObject {
    @Published var items: [ToDoItem] = []
    
    func addItem(title: String) {
        let newItem = ToDoItem(name: title, dueDate: Date(), isCompleted: false)
        items.append(newItem)
    }
    
    func updateItem(_ item: ToDoItem, newTitle: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].name = newTitle
        }
    }
    
    func toggleCompletion(_ item: ToDoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

