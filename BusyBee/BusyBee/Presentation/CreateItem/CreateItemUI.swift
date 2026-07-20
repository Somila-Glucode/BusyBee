import SwiftUI
import SwiftData

struct CreateItemUI: View {
    
    var body: some View {
        NavigationStack {
            ItemForm()
        }
    }
    
    struct ItemForm: View {
        @Environment(\.theme) private var theme
        @Environment(\.modelContext) private var modelContext
        @Query private var lists: [ToDoList]
        @StateObject private var viewModel = ToDoListViewModel()
        
        @State private var itemName: String = ""
        @State private var date: Date = .init()
        @State private var selectedList: ToDoList?
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 19) {
                    
                    Text("ITEM NAME")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    
                    TextField(text: $itemName, prompt: Text("e.g. Bench press").foregroundStyle(theme.containerText)) {
                                           Text("Item Name")
                                       }
                                       .foregroundStyle(theme.containerText)
                                       .padding(12)
                                       .background(theme.primaryColor)
                                       .cornerRadius(12)
                    
                    Text("FINISH DATE")
                                           .font(.subheadline)
                                           .foregroundStyle(.gray)
                                       
                                       DatePicker("Date", selection: $date, displayedComponents: .date)
                                           .datePickerStyle(.graphical)
                                           .tint(theme.containerText)
                                           .environment(\.colorScheme, .dark)
                                           .padding(8)
                                           .frame(maxWidth: .infinity)
                                           .background(theme.primaryColor)
                                           .cornerRadius(12)
                    
                    Text("LIST")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    HStack(spacing: 12) {
                        Menu {
                            ForEach(lists) { list in
                                Button(list.name) {
                                    selectedList = list
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedList?.name ?? "Choose a list")
                                    .foregroundStyle(theme.containerText)
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(theme.containerText)
                            }
                        }
                        
                        Divider().frame(height: 20)
                        
                        AddListSheet()
                    }
                    .padding(12)
                    .background(theme.primaryColor)
                    .cornerRadius(12)
                    
                    Button(action: {
                        guard let selectedList else { return }
                        viewModel.addItem(name: itemName, dueDate: date, to: selectedList, context: modelContext)
                        itemName = ""
                    }) {
                        Text("Save")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                    .background(theme.primaryColor)
                    .cornerRadius(12)
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Item")
                        .font(.headline)
                        .foregroundStyle(theme.textColor)
                }
            }
        }
    }
    
    struct AddListSheet: View {
        @Environment(\.theme) private var theme
        @State private var showCover = false
        
        var body: some View {
            Button(action: { showCover = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(theme.containerText)
                    Text("Add List")
                        .foregroundStyle(theme.containerText)
                        .font(.subheadline.bold())
                }
            }
            .fullScreenCover(isPresented: $showCover) {
                AddListSheetContent()
            }
        }
    }
    
    struct AddListSheetContent: View {
        @Environment(\.dismiss) private var dismiss
        @Environment(\.theme) private var theme
        @Environment(\.modelContext) private var modelContext
        @StateObject private var viewModel = ToDoListViewModel()
        
        @State private var icon: String = ""
        @State private var listName: String = ""
        @State private var listDescription: String = ""
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 19) {
                        
            Text("ICON")
            .font(.subheadline)
            .foregroundStyle(.gray)
                                            
            TextField(text: $icon, prompt: Text("🏋️").foregroundStyle(theme.containerText)) {Text("Icon")}
            .multilineTextAlignment(.center)
            .foregroundStyle(theme.containerText)
            .padding(12)
            .frame(width: 56)
            .background(theme.primaryColor)
            .cornerRadius(12)
            .onChange(of: icon) { _, newValue in if let last = newValue.last {icon = String(last)}}
                        
            Text("LIST NAME")
            .font(.subheadline)
            .foregroundStyle(.gray)
                                               
            TextField(text: $listName, prompt: Text("e.g. Gym").foregroundStyle(theme.containerText)) {
            Text("List Name")
            }
            .foregroundStyle(theme.containerText)
            .padding(12)
            .background(theme.primaryColor)
            .cornerRadius(12)
                        
            Text("DESCRIPTION")
            .font(.subheadline)
            .foregroundStyle(.gray)
                                              
            TextEditor(text: $listDescription)
            .frame(height: 120)
            .padding(8)
            .background(theme.primaryColor.opacity(0.12))
            .cornerRadius(12)
                        
                        Button(action: {
                            viewModel.addList(
                                name: listName,
                                description: listDescription,
                                icon: icon,
                                context: modelContext
                            )
                            dismiss()
                        }) {
                            Text("Save")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(16)
                        .background(theme.primaryColor)
                        .cornerRadius(12)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("Add List")
                            .font(.headline)
                            .foregroundStyle(theme.textColor)
                    }
                }
            }
        }
    }
}



#Preview {
    CreateItemUI()
}
