import SwiftUI

struct DisplayListUI: View {
    var body: some View {
        FullListCard(
            title: "Gym",
            emoji: "🏋️",
            subtitle: "This is the description for the list",
            items: [
                FullListItemUI(name: "Pushups", dueDate: "Today"),
                FullListItemUI(name: "Bench press", dueDate: "Tomorrow"),
                FullListItemUI(name: "Dead lift", dueDate: "Friday")
            ],
            cardColor: Color.blue
        )
    }
}

struct FullListCard: View {
    let title: String
    let emoji: String
    let subtitle: String
    let items: [FullListItemUI]
    let cardColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 10) {
                Text(emoji)
                    .font(.title3)
                    .frame(width: 36, height: 36)
                    .background(.white)
                    .cornerRadius(8)
                
                Text(title)
                    .font(.headline).bold()
                    .foregroundStyle(.white)
            }
                
                VStack(spacing: 10) {
                    ForEach(items, id: \.name) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(item.name)
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.white)
                                
                                Button(action: {}) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            
                            
                            Text(item.dueDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }
            
            DeleteList()
            
            }
            
            
            .frame(width: 200, height: 250)
            .padding(16)
            .background(cardColor)
            .cornerRadius(12)
        }
    }

struct DeleteList : View {
    @State private var isDelete: Bool = false
    var body: some View {
        Button(action: {
            isDelete.toggle()
        }) {
            Image(systemName: "trash")
        }
        .foregroundColor(.white)
        .padding(.trailing, 10)
    }
}
    


struct FullListItemUI {
    let name: String
    let dueDate: String
}
    
    #Preview {
        DisplayListUI()
    }

