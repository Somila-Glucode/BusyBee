import SwiftUI

struct DisplayListUI: View {
    @Environment(\.theme) private var theme
    @State private var showSearch = false
    @State private var showAddList = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            theme.backgroundColor
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    DisplayListHeader(
                        showSearch: $showSearch,
                    )
                    
                    if showSearch {
                        SearchBar()
                    }
                    
                    FullListCard(
                        title: "Gym",
                        emoji: "🏋️",
                        subtitle: "This is the description for the list",
                        items: [
                            FullListItemUI(name: "Pushups", dueDate: "Today"),
                            FullListItemUI(name: "Bench press", dueDate: "Tomorrow"),
                            FullListItemUI(name: "Dead lift", dueDate: "Friday")
                        ],
                        cardColor: theme.primaryColor
                    )
                    FullListCard(
                        title: "Study",
                        emoji: "📚",
                        subtitle: "This is the description for the list",
                        items: [
                            FullListItemUI(name: "Pushups", dueDate: "Today"),
                            FullListItemUI(name: "Bench press", dueDate: "Tomorrow"),
                           
                        ],
                        cardColor: theme.primaryColor
                    )
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
            
            AddButton()
                .padding()
                .onTapGesture {
                    showAddList = true
                }
        }
        .fullScreenCover(isPresented: $showAddList) {
            //AddListContent()
        }
    }
}

struct DisplayListHeader: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @Binding var showSearch: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.textColor)
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("My Lists")
                    .font(.largeTitle.bold())
                    .foregroundStyle(theme.textColor)
                
                Text("2 lists")
                    .font(.subheadline)
                    .foregroundStyle(theme.textColor.opacity(0.6))
            }
            
            Spacer()
            
            Button {
                withAnimation(.spring()) {
                    showSearch.toggle()
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.textColor)
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct SearchBar: View {
    @State private var searchText = ""
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            
            TextField("Search lists", text: $searchText)
                .textFieldStyle(.plain)
        }
        .padding(12)
        .background(Color.gray.opacity(0.12))
        .cornerRadius(12)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct FullListCard: View {
    let title: String
    let emoji: String
    let subtitle: String
    let cardColor: Color
    
    @State private var items: [FullListItemUI]
    @Environment(\.theme) private var theme
    
    init(title: String, emoji: String, subtitle: String, items: [FullListItemUI], cardColor: Color) {
        self.title = title
        self.emoji = emoji
        self.subtitle = subtitle
        self.cardColor = cardColor
        self._items = State(initialValue: items)
    }
    
    private var activeItems: [FullListItemUI] {
        items.filter { !$0.isCompleted }
    }
    
    private var completedItems: [FullListItemUI] {
        items.filter { $0.isCompleted }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 12) {
                Text(emoji)
                    .font(.largeTitle)
                    .frame(width: 56, height: 56)
                    .background(theme.containerText)
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title2.bold())
                        .foregroundStyle(theme.containerText)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(theme.containerText.opacity(0.8))
                        .lineLimit(5)
                }
                
                Spacer()
                
                DeleteList()
            }
            
            VStack(spacing: 10) {
                ForEach(activeItems) { item in
                    itemRow(item)
                }
            }
            
            if !completedItems.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("COMPLETED")
                        .font(.caption.bold())
                        .foregroundStyle(theme.containerText.opacity(0.6))
                        .padding(.top, 4)
                    
                    ForEach(completedItems) { item in
                        itemRow(item)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(theme.primaryColor)
        .cornerRadius(12)
    }
    
    private func itemRow(_ item: FullListItemUI) -> some View {
        HStack(alignment: .top, spacing: 6) {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .strikethrough(item.isCompleted)
                    .opacity(item.isCompleted ? 0.6 : 1)
                
                Text(item.dueDate)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer(minLength: 8)
            
            Button {
                withAnimation(.spring()) {
                    if let index = items.firstIndex(where: { $0.id == item.id }) {
                        items[index].isCompleted.toggle()
                    }
                }
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.green)
            }
            
            Button {
                withAnimation(.spring()) {
                    items.removeAll { $0.id == item.id }
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
    }
}

struct DeleteList: View {
    @State private var isDelete: Bool = false
    @Environment(\.theme) private var theme
    var body: some View {
        Button(action: {
            isDelete.toggle()
        }) {
            Image(systemName: "trash")
                .foregroundColor(.red)
                .frame(width: 36, height: 36)
                .background(theme.containerText)
                .cornerRadius(12)
        }
    }
}

struct FullListItemUI: Identifiable {
    let id = UUID()
    let name: String
    let dueDate: String
    var isCompleted: Bool = false
}

#Preview {
    DisplayListUI()
}
