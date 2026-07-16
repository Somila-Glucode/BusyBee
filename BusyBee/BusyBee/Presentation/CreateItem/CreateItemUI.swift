import SwiftUI

struct CreateItemUI: View {
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    ItemForm()
                }
                
            }
        }
    }
    
    struct ItemForm: View {
        
        @State private var firstName: String = ""
        @State private var lastName: String = ""
        @State private var date: Date = .init()
        
        var body: some View {
            Form {
                Section("Item Name") {
                    TextField("", text: $firstName)
                    
                }
                Section(header: Text("Description")) {
                    TextField("", text: $lastName)
                        .frame(height: 200)
                }
                Section("Finish Date")
                {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .tint(.red)
                    DatePicker("Time", selection: $date, displayedComponents: .hourAndMinute)
                        .tint(.red)
                }
                
                Section("List")
                {
                    List {
                        Picker("Choose A List", selection: .constant("3")) {
                            Text("Gym")
                                .tag("1")

                            Section("Study") {
                            }
                            Text("Study")
                                .tag("3")
                        }
                    }
                    AddListSheet()
                    
                }
                Button("Save") {
                    
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 12))
                
            }
        }
    }
    
    struct AddListSheet: View {
        @State private var showCover = false
        
        var body: some View {
            Button("Add List", systemImage: "hand.tap", action: { showCover = true })
                .padding(.horizontal)
                .fullScreenCover(isPresented: $showCover) {
                    AddListSheetContent()
                }
        }
    }
    
    struct AddListSheetContent: View {
        @Environment(\.dismiss) private var dismiss
        @State private var firstName: String = ""
        @State private var lastName: String = ""
        
        var body: some View {
            NavigationStack {
                VStack {
                    Form {
                        Section("Icon") {
                            TextField("", text: $firstName)
                            
                        }
                        Section("List Name") {
                            TextField("", text: $firstName)
                            
                        }
        
                        Section(header: Text("Description")) {
                            TextField("", text: $lastName)
                                .frame(height: 200)
                        }
                        
                        Button("Save") {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 12))
                        
                    }

                }
                .navigationTitle("Add List")
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

