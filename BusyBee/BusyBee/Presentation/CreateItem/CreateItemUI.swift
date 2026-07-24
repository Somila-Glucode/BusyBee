import SwiftUI
import SwiftData

struct CreateItemUI: View {
    
    var body: some View {
        NavigationStack {
            ItemForm()
        }
    }
    
    struct ItemForm: View {
        
        @Environment(\.modelContext) private var modelContext
        @Query private var lists: [ToDoList]
        @StateObject private var viewModel = ToDoListViewModel()
        @Environment(\.dismiss) private var dismiss
        
        @State private var itemName: String = ""
        @State private var date: Date = .init()
        @State private var selectedList: ToDoList?
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 19) {
                    
                    Text("ITEM NAME")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    TextField(text: $itemName, prompt: Text("e.g. Bench press").foregroundStyle(Color("containerText"))) {
                        Text("Item Name")
                    }
                    .foregroundStyle(Color("containerText"))
                    .padding(12)
                    .background(Color("primaryColor"))
                    .cornerRadius(12)
                    
                    Text("FINISH DATE")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .tint(Color("containerText"))
                        .environment(\.colorScheme, .dark)
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(Color("primaryColor"))
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
                                    .foregroundStyle(Color("containerText"))
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(Color("containerText"))
                            }
                        }
                        
                        Divider().frame(height: 20)
                        
                        AddListSheet()
                    }
                    .padding(12)
                    .background(Color("primaryColor"))
                    .cornerRadius(12)
                    
                    Button(action: {
                        guard let selectedList else { return }
                        viewModel.addItem(name: itemName, dueDate: date, to: selectedList, context: modelContext)
                        itemName = ""
                        
                        dismiss()
                    }) {
                        Text("Save")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                    .background(Color("primaryColor"))
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
                    Text("New Item")
                        .font(.headline)
                        .foregroundStyle(Color("textColor"))
                }
            }
        }
    }
    
    struct AddListSheet: View {
        
        @State private var showCover = false
        
        var body: some View {
            Button(action: { showCover = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(Color("containerText"))
                    Text("Add List")
                        .foregroundStyle(Color("containerText"))
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
                        
                        TextField(text: $icon, prompt: Text("🏋️").foregroundStyle(Color("containerText"))) {Text("Icon")}
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color("containerText"))
                            .padding(12)
                            .frame(width: 56)
                            .background(Color("primaryColor"))
                            .cornerRadius(12)
                            .onChange(of: icon) { _, newValue in if let last = newValue.last {icon = String(last)}}
                        
                        Text("LIST NAME")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        TextField(text: $listName, prompt: Text("e.g. Gym").foregroundStyle(Color("containerText"))) {
                            Text("List Name")
                        }
                        .foregroundStyle(Color("containerText"))
                        .padding(12)
                        .background(Color("primaryColor"))
                        .cornerRadius(12)
                        
                        Text("DESCRIPTION")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        TextField(text: $listDescription, prompt: Text("e.g. This is a list containing your gym items").foregroundStyle(Color("containerText"))) {
                            Text("Item Name")
                        }
                        .frame(height: 120)
                        .foregroundStyle(Color("containerText"))
                        .padding(12)
                        .background(Color("primaryColor"))
                        .cornerRadius(12)
                        
                        Button(action: {
                            guard !listName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                  !icon.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                return
                            }
                            
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
                        .background(Color("primaryColor"))
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
                            .foregroundStyle(Color("textColor"))
                    }
                }
            }
        }
    }
    
}



#Preview {
    CreateItemUI()
}
