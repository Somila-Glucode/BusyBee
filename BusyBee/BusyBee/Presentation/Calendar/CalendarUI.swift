import SwiftUI

struct CalendarUI: View {
    @Environment(\.theme) private var theme
    @State private var selectedDate: Date = .init()
    
    let allItems: [FullListItemUI] = [
        FullListItemUI(name: "Pushups", dueDate: "Today"),
        FullListItemUI(name: "Bench press", dueDate: "Tomorrow")
    ]
    
    var body: some View {
        ZStack {
            theme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                
                HStack(alignment: .top) {
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text("Calendar")
                            .font(.largeTitle.bold())
                            .foregroundStyle(theme.textColor)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                  
                    
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .tint(theme.containerText)
                    .padding(.horizontal)
                    .padding(12)
                    .background(theme.primaryColor.opacity(0.3))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Text("ITEMS")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        ForEach(allItems, id: \.name) { item in
                            HStack {
                                Text(item.name)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(theme.textColor)
                                Spacer()
                                Text(item.dueDate)
                                    .font(.caption)
                                    .foregroundStyle(theme.textColor.opacity(0.6))
                            }
                            .padding(12)
                            .background(theme.primaryColor.opacity(0.3))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
            }
        }
    }
}

#Preview {
    CalendarUI()
}

