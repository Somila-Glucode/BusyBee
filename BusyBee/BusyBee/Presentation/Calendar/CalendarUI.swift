import SwiftUI
import SwiftData

struct CalendarUI: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ToDoItem.dueDate) private var toDoItem: [ToDoItem]
    @StateObject private var viewModel = ToDoListViewModel()
    
    @State private var selectedDate: Date = .init()
    
    var filteredItems: [ToDoItem] {
        toDoItem.filter { item in
            Calendar.current.isDate(item.dueDate, inSameDayAs: selectedDate)
        }
    }
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    
                    CalendarHeader()
                    
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .tint(Color("containerText"))
                    .environment(\.colorScheme, .dark)
                    .frame(height: 340)
                    .padding(14)
                    .background(Color("primaryColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: Color("primaryColor").opacity(0.25), radius: 12, y: 6)
                    
                    HStack(spacing: 8) {
                        Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        if !filteredItems.isEmpty {
                            Text("\(filteredItems.count)")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .frame(width: 20, height: 20)
                                .background(Color("primaryColor"))
                                .clipShape(Circle())
                        }
                    }
                    
                    if filteredItems.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle")
                                .font(.title2)
                                .foregroundStyle(Color("primaryColor").opacity(0.5))
                            
                            Text("Nothing due this day")
                                .font(.subheadline.bold())
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(filteredItems) { item in
                                itemRow(item)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func itemRow(_ item: ToDoItem) -> some View {
        HStack(spacing: 10) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    viewModel.toggleCompletion(item, context: modelContext)
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18))
                    .foregroundStyle(item.isCompleted ? .green : Color("containerText").opacity(0.5))
            }
            
            Text(item.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("containerText").opacity(item.isCompleted ? 0.5 : 1))
                .strikethrough(item.isCompleted, color: Color("containerText").opacity(0.5))
            
            Spacer()
            
            Text(item.list?.name ?? "")
                .font(.caption)
                .foregroundStyle(Color("containerText"))
            
            
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color("primaryColor"))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct CalendarHeader: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color("textColor"))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            
            Spacer()
            
            Text("Calendar")
                .font(.largeTitle.bold())
                .foregroundStyle(Color("textColor"))
            
            Spacer()
            
            Color.clear
                .frame(width: 32, height: 32)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CalendarUI()
}
