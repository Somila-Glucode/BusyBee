import Foundation
import Combine
import SwiftUI

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
    
    var conditionText: String {
        guard let condition = weather?.weather.first?.description else { return "--" }
        return condition
    }
    
    var backgroundGradientColors: [Color] {
        guard let id = weather?.weather.first?.id else {
            return [Color.blue.opacity(0.6), Color.blue.opacity(0.9)]
        }

        switch id {
        case 200...232: // thunderstorm
            return [Color.gray.opacity(0.9), Color.black.opacity(0.8)]

        case 300...321, 500...531: // drizzle / rain
            return [Color.blue.opacity(0.5), Color.gray.opacity(0.8)]

        case 600...622: // snow
            return [Color.cyan.opacity(0.4), Color.blue.opacity(0.5)]

        case 701...781: // fog / atmosphere
            return [Color.gray.opacity(0.5), Color.gray.opacity(0.7)]

        case 800: // sunny / clear
            return [
                Color.yellow.opacity(0.9),
                Color.orange.opacity(0.8),
                Color.blue.opacity(0.6)
            ]

        case 801...804: // clouds
            return [Color.blue.opacity(0.4), Color.gray.opacity(0.6)]

        default:
            return [Color.blue.opacity(0.6), Color.blue.opacity(0.9)]
        }
    }
    
    func fetchWeather(city: String) {
        cancellable = weatherService.getWeather(for: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { weather in
                self.weather = weather
            })
    }
    
    func fetchWeather(lat: Double, lon: Double) {
        cancellable = weatherService.getWeather(lat: lat, lon: lon)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { weather in
                self.weather = weather
            })
    }
}
