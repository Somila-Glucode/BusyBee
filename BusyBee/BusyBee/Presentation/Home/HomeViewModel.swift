import Foundation
import SwiftData
import Combine
import SwiftUI


class HomeViewModel: ObservableObject {
    
    var currentHour: Int {
        Calendar.current.component(.hour, from: Date())
    }
    
    var formattedDate = Date().formatted(.dateTime.weekday(.wide).day().month(.wide).year().locale(Locale(identifier: "en_GB")))
    
    func greetingTime() -> String {
        
        var greetingTime: String {
            if currentHour < 12 {
                return "Good Morning"
            } else if currentHour < 18 {
                return "Good Afternoon"
            } else {
                return "Good Evening"
            }
        }
        return greetingTime
    }
    
    func showList(id: UUID, context: ModelContext) -> ToDoList? {
        let predicate = #Predicate<ToDoList> { list in
            list.id == id
        }
        var descriptor = FetchDescriptor<ToDoList>(predicate: predicate)
        descriptor.fetchLimit = 1
        
        return try? context.fetch(descriptor).first
    }
}
