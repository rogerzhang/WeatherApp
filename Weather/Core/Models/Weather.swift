import Foundation

// MARK: - WeatherError
enum WeatherError: Error, LocalizedError {
    case networkError(String)
    case decodingError(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .unknownError:
            return "Unknown error occurred"
        }
    }
}

struct WeatherResponse: Codable {
    let main: Main
    let name: String
    let dt: TimeInterval
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Equatable {
    let city: String
    let temperature: Double
    let lastUpdated: Date
    
    init(from response: WeatherResponse) {
        self.city = response.name
        self.temperature = response.main.temp
//        self.lastUpdated = Date(timeIntervalSince1970: response.dt) // Server timestamp is not refreshed every minute
        self.lastUpdated = Date() // Use current local time instead of API timestamp
    }
}

enum City: String, CaseIterable {
    case london = "London"
    case helsinki = "Helsinki"
    
    var coordinates: (lat: Double, lon: Double) {
        switch self {
        case .london:
            return (51.5073359, -0.12765)
        case .helsinki:
            return (60.1674881, 24.9427473)
        }
    }
}
