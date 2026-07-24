import Foundation
import Combine

private enum APIKEY {
    static let key = "925ac7cd1d401c1dc7f6fa82a1254016"
}

class WeatherService {
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(APIKEY.key)&units=metric") else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, Error> {
        guard let url = URL(string: "\(baseURL)?lat=\(lat)&lon=\(lon)&appid=\(APIKEY.key)&units=metric") else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
