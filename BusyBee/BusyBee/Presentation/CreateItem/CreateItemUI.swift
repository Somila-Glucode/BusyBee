import SwiftUI

struct CreateItemUI: View {
    
    var body: some View {
        NavigationStack {
            ItemForm()
        }
    }
    
    struct ItemForm: View {
        
        @State private var itemName: String = ""
        @State private var date: Date = .init()
        
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 19) {
                    
                    Text("ITEM")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    TextField("e.g. Bench press", text: $itemName)
                        .padding(12)
                        .background(Color.gray.opacity(0.12))
                        .cornerRadius(12)
                    
                    Text("FINISH DATE")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    VStack(spacing: 0) {
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .tint(.blue)
                            .padding(12)
                        
                        Divider()
                        
                        DatePicker("Time", selection: $date, displayedComponents: .hourAndMinute)
                            .tint(.blue)
                            .padding(12)
                    }
                    .background(Color.gray.opacity(0.12))
                    .cornerRadius(12)
                    
                    Text("LIST")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                    
                    VStack(spacing: 0) {
                        Picker("Choose A List", selection: .constant("3")) {
                            Text("Gym").tag("1")
                            Text("Study").tag("3")
                        }
                        .padding(12)
                        
                        Divider()
                        
                        AddListSheet()
                    }
                    .background(Color.gray.opacity(0.12))
                    .cornerRadius(12)
                    
                    Button(action: {}) {
                        Text("Save")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(16)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    struct AddListSheet: View {
        @State private var showCover = false
        
        var body: some View {
            Button(action: { showCover = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.blue)
                    Text("Add New List")
                        .foregroundStyle(.blue)
                        .font(.subheadline.bold())
                    Spacer()
                }
            }
            .padding(12)
            .fullScreenCover(isPresented: $showCover) {
                AddListSheetContent()
            }
        }
    }
    
    struct AddListSheetContent: View {
        @Environment(\.dismiss) private var dismiss
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
                        
                        TextField("🏋️", text: $icon)
                            .padding(12)
                            .background(Color.gray.opacity(0.12))
                            .cornerRadius(12)
                        
                        Text("LIST NAME")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        TextField("e.g. Gym", text: $listName)
                            .padding(12)
                            .background(Color.gray.opacity(0.12))
                            .cornerRadius(12)
                        
                        Text("DESCRIPTION")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        TextEditor(text: $listDescription)
                            .frame(height: 120)
                            .padding(8)
                            .background(Color.gray.opacity(0.12))
                            .cornerRadius(12)
                        
                        Button(action: {}) {
                            Text("Save")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(16)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
                .navigationTitle("Add List")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CreateItemUI()
}
