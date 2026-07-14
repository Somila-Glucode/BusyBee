import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    private let weatherService: WeatherService
    private var cancellable: AnyCancellable?
    @Published var weather: WeatherResponse?
    
    init(service: WeatherService) {
          self.weatherService = service  
      }
    
    var temperatureText: String {
        guard let temp = weather?.main.temp else { return "--" }
        return "\(String(format: "%.1f", temp))°C"
    }
    
    var sunriseText: String {
        guard let sunrise = weather?.sys.sunrise else { return "--" }
        return Date(timeIntervalSince1970: TimeInterval(sunrise)).formatted(date: .omitted, time: .shortened)
    }
    
    var sunsetText: String {
        guard let sunset = weather?.sys.sunset else { return "--" }
        return Date(timeIntervalSince1970: TimeInterval(sunset)).formatted(date: .omitted, time: .shortened)
    }
    
    
    func fetchWeather(city: String) {
        cancellable = weatherService.getWeather(for: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { weather in
                self.weather = weather
            })
    }
}
