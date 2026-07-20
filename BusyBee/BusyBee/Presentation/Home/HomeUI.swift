import SwiftUI

struct HomeUI: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                theme.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Greeting()
                        .padding(.top, 25)
                    WeatherCard()
                    OverviewView()
                    Spacer()
                }
                
                AddButton()
                    .padding()
            }
        }
    }
}

struct OverviewView: View {
    @State private var searchText = ""
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 19) {
            Text("OVERVIEW")
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.6))
            
            HStack(spacing: 12) {
                OverviewCard(icon: "calendar", count: 12, label: "Today", color: theme.textColor)
                OverviewCard(icon: "clock", count: 12, label: "Next", color: theme.textColor)
                OverviewCard(icon: "exclamationmark.triangle", count: 3, label: "Late", color: theme.textColor)
            }
            
            Text("ITEMS")
                .font(.subheadline)
                .foregroundStyle(.black.opacity(0.6))
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(theme.textColor)
                
                TextField("Search items", text: $searchText)
                    .textFieldStyle(.plain)
            }
            .padding(12)
            .background(Color.gray.opacity(0.12))
            .cornerRadius(12)
            
            VStack(spacing: 12) {
                ListCard(
                    title: "Gym",
                    emoji: "🏋️",
                    items: [
                        ListItemUI(name: "Pushups", dueDate: "Today"),
                        ListItemUI(name: "Bench press", dueDate: "Tomorrow"),
                        ListItemUI(name: "Dead lift", dueDate: "Friday")
                    ],
                    cardColor: theme.primaryColor
                )
                ListCard(
                    title: "Study",
                    emoji: "📚",
                    items: [
                        ListItemUI(name: "Read notes", dueDate: "Today"),
                        ListItemUI(name: "Practice quiz", dueDate: "Thursday")
                    ],
                    cardColor: theme.primaryColor
                )
            }
        }
        .padding(.horizontal)
    }
}

struct OverviewCard: View {
    let icon: String
    let count: Int
    let label: String
    let color: Color
    
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(theme.containerText)
            
            Text("3")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(theme.containerText)
            
            Text(label)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(theme.containerText.opacity(0.9))
            
            Spacer()
        }
        .padding(16)
        .frame(width: 110, height: 118, alignment: .topLeading)
        .background(theme.primaryColor)
        .cornerRadius(12)
    }
    
}

struct Greeting: View {
    @Environment(\.theme) private var theme
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Good Afternoon, Somila")
                    .font(.title3).bold()
                    .foregroundStyle(theme.textColor)
                
                Text(Date().formatted(.dateTime.weekday(.wide).day().month(.wide).year().locale(Locale(identifier: "en_GB"))))
                    .font(.caption)
                    .foregroundStyle(theme.textColor.opacity(0.7))
            }
            
            Spacer()
            
            Menu {
                Button("Settings", systemImage: "gearshape") {}
                Button("All Lists", systemImage: "pencil") {}
                Button("Calendar", systemImage: "calendar") {}
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.primaryColor)
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct AddButton: View {
    @Environment(\.theme) private var theme
    var body: some View {
        Button(action: {}) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(theme.containerText)
        }
        .padding(16)
        .background(theme.primaryColor)
        .cornerRadius(12)
    }
}

struct ListCard: View {
    let title: String
    let emoji: String
    let items: [ListItemUI]
    let cardColor: Color
    
    @State private var isExpanded = false
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 10) {
                    Text(emoji)
                        .font(.title3)
                        .frame(width: 36, height: 36)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Text(title)
                        .font(.headline).bold()
                        .foregroundStyle(theme.containerText)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.bold())
                        .foregroundStyle(theme.containerText)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 10) {
                    ForEach(items, id: \.name) { item in
                        HStack {
                            Text(item.name)
                                .font(.subheadline.bold())
                                .foregroundStyle(theme.containerText)
                            
                            Spacer()
                            
                            Text(item.dueDate)
                                .font(.caption)
                                .foregroundStyle(theme.containerText.opacity(0.8))
                        }
                    }
                }
                .padding(.top, 4)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(16)
        .background(theme.primaryColor)
        .cornerRadius(12)
    }
}

struct ListItemUI {
    let name: String
    let dueDate: String
}

struct WeatherCard: View {
    @Environment(\.theme) private var theme
    let location = "London"
    let temperature = 20
    let condition = "Cloudy"
    let sunrise = "07:00"
    let sunset = "18:00"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location)
                        .font(.title3).bold()
                        .foregroundStyle(theme.containerText)
                    
                    Text(condition)
                        .font(.subheadline)
                        .foregroundStyle(theme.containerText.opacity(0.8))
                }
                
                Spacer()
                
                Text("\(temperature)°C")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(theme.containerText)
            }
            
            
            WeatherSYSCard(sunrise: sunrise, sunset: sunset)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.primaryColor)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct WeatherSYSCard: View {
    let sunrise: String
    let sunset: String
    
    var body: some View {
        HStack(spacing: 16) {
            WeatherSysItem(image: "sunrise.fill", title: "Sunrise", time: sunrise)
            Spacer()
            WeatherSysItem(image: "sunset.fill", title: "Sunset", time: sunset)
        }
    }
}

struct WeatherSysItem: View {
    @Environment(\.theme) private var theme
    let image: String
    let title: String
    let time: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: image)
                .font(.title3)
                .foregroundStyle(theme.containerText)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(theme.containerText.opacity(0.8))
                
                Text(time)
                    .font(.caption.bold())
                    .foregroundStyle(theme.containerText)
            }
        }
    }
}

#Preview
{
    HomeUI()
}
