import SwiftUI
import SwiftData
internal import _LocationEssentials

struct HomeUI: View {
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                
                ScrollView {
                    VStack(spacing: 20) {
                        Greeting()
                            .padding(.top, 25)
                        WeatherCard()
                        OverviewView()
                    }
                    .padding(.bottom, 40)
                }
                
            }
        }
    }
}

struct OverviewView: View {
    @State private var searchText = ""
    @Query(sort: \ToDoItem.dueDate) private var allItems: [ToDoItem]
    @Query(sort: \ToDoList.createdAt) private var lists: [ToDoList]
    @StateObject private var viewModel = ToDoListViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var todayItems: [ToDoItem] {
        allItems.filter { Calendar.current.isDate($0.dueDate, inSameDayAs: .now) }
    }
    
    var filteredLists: [ToDoList] {
        searchText.isEmpty ? lists : lists.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 19) {
            
            HStack {
                Text("TODAY")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                if !todayItems.isEmpty {
                    Text("\(todayItems.count)")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                        .background(Color("primaryColor"))
                        .clipShape(Circle())
                }
            }
            
            if todayItems.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .font(.title2)
                        .foregroundStyle(Color("primaryColor").opacity(0.5))
                    
                    Text("Nothing due today")
                        .font(.subheadline.bold())
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                VStack(spacing: 10) {
                    ForEach(todayItems) { item in
                        HStack(spacing: 12) {
                            Text(item.list?.icon ?? "📋")
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(Color.white)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.white)
                                            .lineLimit(1)

                                        Text(item.list?.name ?? "")
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.7))
                                    }
                            Spacer()
                        }
                        .padding(12)
                        .background(Color("primaryColor"))
                        .cornerRadius(12)
                    }
                }
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
            
            if filteredLists.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .font(.title2)
                        .foregroundStyle(Color("primaryColor").opacity(0.5))
                    
                    Text("No lists yet")
                        .font(.subheadline.bold())
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(filteredLists) { list in
                        ListCard(list: list)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct Greeting: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var showAllLists = false
    @State private var showCalendar = false
    @State private var showCreateItem = false
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(viewModel.greetingTime())")
                    .font(.title3).bold()
                    .foregroundStyle(Color("textColor"))
                
                Text("\(viewModel.formattedDate)")
                    .font(.caption)
                    .foregroundStyle(Color("textColor").opacity(0.7))
            }
            
            
            Spacer()
            
            Menu {
                Button("All Lists", systemImage: "pencil") {
                    showAllLists = true
                }
                Button("Calendar", systemImage: "calendar") {
                    showCalendar = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color("textColor"))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
            
            Button {
                showCreateItem = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color("textColor"))
                    .frame(width: 32, height: 32)
                    .contentShape(Rectangle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showAllLists) {
            DisplayListUI()
        }
        .fullScreenCover(isPresented: $showCalendar) {
            CalendarUI()
        }
        .fullScreenCover(isPresented: $showCreateItem) {
            CreateItemUI()
        }
    }
}

struct ListCard: View {
    let list: ToDoList
    
    var completedCount: Int {
        list.items.filter(\.isCompleted).count
    }
    
    var progress: Double {
        list.items.isEmpty ? 0 : Double(completedCount) / Double(list.items.count)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Text(list.icon)
                .font(.title2)
                .frame(width: 44, height: 44)
                .background(Color.white)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(list.name)
                    .font(.headline).bold()
                    .foregroundStyle(Color("containerText"))
                
                Text(list.listDescription)
                    .font(.caption)
                    .foregroundStyle(Color("containerText"))
                    .lineLimit(5)
                
                Text("\(completedCount) of \(list.items.count) items completed")
                    .font(.caption2)
                    .foregroundStyle(Color("containerText"))
            }
            
            Spacer(minLength: 12)
            
            Gauge(value: progress) {
                Text("")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(Color("containerText"))
            .frame(width: 36, height: 36)
        }
        .padding(16)
        .padding(.trailing, 4)
        .frame(maxWidth: .infinity)
        .background(Color("primaryColor"))
        .cornerRadius(12)
    }
}

struct WeatherCard: View {
    
    @StateObject private var weatherViewModel = WeatherViewModel(service: WeatherService())
    @StateObject private var locationManager = LocationManager()
    
    let fallbackCity = "Johannesburg"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(weatherViewModel.weather?.name ?? fallbackCity)
                        .font(.title3).bold()
                        .foregroundStyle(Color("containerText"))
                    
                    Text(weatherViewModel.conditionText)
                        .font(.subheadline)
                        .foregroundStyle(Color("containerText").opacity(0.8))
                }
                
                Spacer()
                
                Text(weatherViewModel.temperatureText)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(Color("containerText"))
            }
            
            WeatherSYSCard(sunrise: weatherViewModel.sunriseText, sunset: weatherViewModel.sunsetText)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: weatherViewModel.backgroundGradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .animation(.easeInOut(duration: 1), value: weatherViewModel.backgroundGradientColors)
        )
        .cornerRadius(12)
        .padding(.horizontal)
        .task {
            locationManager.checkLocationAuthorization()
        }
        .onChange(of: locationManager.lastKnownLocation?.latitude) { _, _ in
            if let coordinate = locationManager.lastKnownLocation {
                weatherViewModel.fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude)
            } else {
                weatherViewModel.fetchWeather(city: fallbackCity)
            }
        }
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
                .foregroundStyle(Color("containerText"))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(Color("containerText").opacity(0.8))
                
                Text(time)
                    .font(.caption.bold())
                    .foregroundStyle(Color("containerText"))
            }
        }
    }
}

#Preview
{
    HomeUI()
}
