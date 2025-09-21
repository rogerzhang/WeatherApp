import Foundation
import Moya

protocol WeatherServiceProtocol {
    func getWeather(for city: City, completion: @escaping (Result<Weather, WeatherError>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    private let provider = MoyaProvider<WeatherAPI>()
    
    func getWeather(for city: City, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        let coordinates = city.coordinates
        provider.request(.getWeather(lat: coordinates.lat, lon: coordinates.lon)) { result in
            switch result {
            case .success(let response):
                do {
                    let weatherResponse = try response.map(WeatherResponse.self)
                    let weather = Weather(from: weatherResponse)
                    completion(.success(weather))
                } catch {
                    completion(.failure(WeatherError.decodingError(error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(WeatherError.networkError(error.localizedDescription)))
            }
        }
    }
}
