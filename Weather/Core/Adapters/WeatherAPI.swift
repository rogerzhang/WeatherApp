import Foundation
import Moya

enum WeatherAPI {
    case getWeather(lat: Double, lon: Double)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5")!
    }
    
    var path: String {
        switch self {
        case .getWeather:
            return "/weather"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getWeather(let lat, let lon):
            return .requestParameters(
                parameters: [
                    "lat": lat,
                    "lon": lon,
                    "appid": "7c30e3574ca6b0115b4930259e9a0e99",
                    "units": "metric"
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
