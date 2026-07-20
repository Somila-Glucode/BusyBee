import Foundation
import SwiftData
import Combine
import SwiftUI

class ToDoListViewModel: ObservableObject {
    
    func addList(name: String, description: String, icon: String, context: ModelContext) {
        let newList = ToDoList(name: name, listDescription: description, icon: icon)
        context.insert(newList)
        try? context.save()
    }
    
    func addItem(name: String, dueDate: Date, to list: ToDoList, context: ModelContext) {
        let newItem = ToDoItem(name: name, dueDate: dueDate, isCompleted: false)
        newItem.list = list
        list.items.append(newItem)
        context.insert(newItem)
        try? context.save()
    }
    
    
    
    func toggleCompletion(_ item: ToDoItem, context: ModelContext) {
        item.isCompleted.toggle()
        try? context.save()
    }
    
    func deleteItem(_ item: ToDoItem, context: ModelContext) {
        context.delete(item)
        try? context.save()
    }
    
    func deleteList(_ list: ToDoList, context: ModelContext) {
        context.delete(list) 
        try? context.save()
    }
}

