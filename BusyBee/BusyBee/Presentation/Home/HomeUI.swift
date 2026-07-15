import SwiftUI

struct HomeUI: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 16) {
                    Greeting()
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 19) {
            Text("OVERVIEW")
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            HStack(spacing: 12) {
                OverviewCard(icon: "play.fill", count: 12, label: "Today", color: .blue)
                OverviewCard(icon: "person.crop.circle.badge.ellipsis", count: 12, label: "Upcoming", color: .blue)
                OverviewCard(icon: "play.fill", count: 3, label: "Overdue", color: .blue)
            }
            
            Text("ITEMS")
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
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
                    cardColor: Color.blue
                )
                ListCard(
                    title: "Study",
                    emoji: "📚",
                    items: [
                        ListItemUI(name: "Read notes", dueDate: "Today"),
                        ListItemUI(name: "Practice quiz", dueDate: "Thursday")
                    ],
                    cardColor: Color.blue
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
            
            Text("3")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.white)
            
            Text(label)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white.opacity(0.9))
            
            Spacer()
        }
        .padding(16)
        .frame(width: 110, height: 118, alignment: .topLeading)
        .background(color)
        .cornerRadius(12)
    }
    
}

struct Greeting: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Good Afternoon, Somila")
                .font(.title3).bold()
                .foregroundStyle(.black)
            
            Text(Date().formatted(.dateTime.weekday(.wide).day().month(.wide).year().locale(Locale(identifier: "en_GB"))))
                .font(.caption)
                .foregroundStyle(.black.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
}

struct AddButton: View {
    var body: some View {
        Button(action: {}) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(16)
        .background(Color.blue)
        .cornerRadius(12)
    }
}

struct ListCard: View {
    let title: String
    let emoji: String
    let items: [ListItemUI]
    let cardColor: Color
    
    @State private var isExpanded = false
    
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
                        .background(.white)
                        .cornerRadius(8)
                    
                    Text(title)
                        .font(.headline).bold()
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 10) {
                    ForEach(items, id: \.name) { item in
                        HStack {
                            Text(item.name)
                                .font(.subheadline.bold())
                                .foregroundStyle(.white)
                            
                            Spacer()
                            
                            Text(item.dueDate)
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                }
                .padding(.top, 4)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(16)
        .background(cardColor)
        .cornerRadius(12)
    }
}

struct ListItemUI {
    let name: String
    let dueDate: String
}

struct WeatherCard: View {
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
                        .foregroundStyle(.white)
                    
                    Text(condition)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("\(temperature)°C")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Divider()
                .background(.white.opacity(0.5))
            
            WeatherSYSCard(sunrise: sunrise, sunset: sunset)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue)
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
    let image: String
    let title: String
    let time: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: image)
                .font(.title3)
                .foregroundStyle(.white)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(time)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview
{
    HomeUI()
}
