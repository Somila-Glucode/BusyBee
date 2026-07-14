import SwiftUI

struct ContentView: View {
    @State private var city: String = ""
    @StateObject private var weatherViewModel = WeatherViewModel(service: WeatherService())
    
    var body: some View {
        VStack {
            TextField("Enter city", text: $city, onCommit: {
                weatherViewModel.fetchWeather(city: city)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if let weather = weatherViewModel.weather {
                Text("Weather in \(weather.name)")
                    .font(.title)
                    .padding()
                
                Text(weatherViewModel.temperatureText)
                    .font(.headline)
                    .padding()
                
                Text(weather.weather.first?.description.capitalized ?? "")
                    .font(.subheadline)
                
                Text(weatherViewModel.sunriseText)
                    .font(.headline)
                    .padding()
                
                Text(weatherViewModel.sunsetText)
                    .font(.headline)
                    .padding()
            }
        }
        .padding()
    }
}


