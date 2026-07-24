import SwiftUI
import SwiftData

struct DisplayListUI: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ToDoList.createdAt) private var lists: [ToDoList]
    @StateObject private var viewModel = ToDoListViewModel()
    
    @State private var showSearch = false
    @State private var searchText = ""
    
    var filteredLists: [ToDoList] {
        searchText.isEmpty ? lists : lists.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    DisplayListHeader(showSearch: $showSearch, listCount: lists.count)
                    
                    if showSearch {
                        SearchBar(searchText: $searchText)
                    }
                    
                    if filteredLists.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "checkmark.circle")
                                .font(.title2)
                                .foregroundStyle(Color("primaryColor").opacity(0.5))
                            
                            Text(lists.isEmpty ? "No lists yet" : "No matches found")
                                .font(.subheadline.bold())
                                .foregroundStyle(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 500)
                    } else {
                        ForEach(filteredLists) { list in
                            FullListCard(list: list, viewModel: viewModel)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 80)
            }
        }
    }
}

struct DisplayListHeader: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showSearch: Bool
    let listCount: Int
    @State private var showCreateItem = false
    
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
            
            VStack(spacing: 2) {
                Text("All Lists")
                    .font(.title.bold())
                    .foregroundStyle(Color("textColor"))
                
                Text("\(listCount) list\(listCount == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundStyle(Color("textColor").opacity(0.6))
            }
            
            Spacer()
            
            Button {
                showCreateItem = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color("textColor"))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            
            Button {
                withAnimation(.spring()) {
                    showSearch.toggle()
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color("textColor"))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
        }
        .frame(maxWidth: .infinity)
        .fullScreenCover(isPresented: $showCreateItem) {
            CreateItemUI()
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
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
    let list: ToDoList
    let viewModel: ToDoListViewModel
    
    @Environment(\.modelContext) private var modelContext
    
    private var activeItems: [ToDoItem] {
        list.items.filter { !$0.isCompleted }
    }
    
    private var completedItems: [ToDoItem] {
        list.items.filter { $0.isCompleted }
    }
    
    private var progress: Double {
        list.items.isEmpty ? 0 : Double(completedItems.count) / Double(list.items.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            HStack(spacing: 14) {
                Text(list.icon)
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .background(Color("containerText"))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(list.name)
                        .font(.title3.bold())
                        .foregroundStyle(Color("containerText"))
                    
                    Text(list.listDescription)
                        .font(.caption)
                        .foregroundStyle(Color("containerText").opacity(0.7))
                        .lineLimit(2)
                }
                
                Spacer(minLength: 12)
                
                Menu {
                    Button(role: .destructive) {
                        viewModel.deleteList(list, context: modelContext)
                    } label: {
                        Label("Delete List", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color("containerText").opacity(0.7))
                        .frame(width: 28, height: 28)
                        .contentShape(Rectangle())
                }
            }
            
            if !activeItems.isEmpty {
                VStack(spacing: 8) {
                    ForEach(activeItems) { item in
                        itemRow(item)
                    }
                }
            }
            
            if !completedItems.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color("containerText").opacity(0.15))
                            .frame(height: 1)
                        
                        Text("COMPLETED")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color("containerText").opacity(0.5))
                            .fixedSize()
                        
                        Rectangle()
                            .fill(Color("containerText").opacity(0.15))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 2)
                    
                    ForEach(completedItems) { item in
                        itemRow(item)
                    }
                }
            }
            
            if list.items.isEmpty {
                Text("No items yet")
                    .font(.subheadline)
                    .foregroundStyle(Color("containerText").opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("primaryColor"))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color("primaryColor").opacity(0.25), radius: 12, y: 6)
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
            
            VStack(alignment: .leading, spacing: 1) {
                Text(item.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color("containerText").opacity(item.isCompleted ? 0.5 : 1))
                    .strikethrough(item.isCompleted, color: Color("containerText").opacity(0.5))
                
                Text(item.dueDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(Color("containerText").opacity(0.5))
            }
            
            Spacer(minLength: 8)
            
            Button {
                withAnimation(.spring(response: 0.3)) {
                    viewModel.deleteItem(item, context: modelContext)
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color("containerText").opacity(0.35))
                    .frame(width: 22, height: 22)
                    .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color("containerText").opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
#Preview {
    DisplayListUI()
}
