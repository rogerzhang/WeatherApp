//
//  MockWeatherService.swift
//  WeatherTests
//
//  Created by roger on 2025/9/21.
//

import Foundation
@testable import Weather

class MockWeatherService: WeatherServiceProtocol {
    var shouldSucceed = true
    var mockWeather: Weather?
    var mockError: WeatherError?
    var fetchWeatherCallCount = 0
    var lastRequestedCity: City?
    
    func getWeather(for city: City, completion: @escaping (Result<Weather, WeatherError>) -> Void) {
        fetchWeatherCallCount += 1
        lastRequestedCity = city
        
        if shouldSucceed {
            let weather = mockWeather ?? Weather(
                city: city.rawValue,
                temperature: 25.0,
                lastUpdated: Date()
            )
            completion(.success(weather))
        } else {
            let error = mockError ?? WeatherError.networkError("Mock network error")
            completion(.failure(error))
        }
    }
    
    func reset() {
        shouldSucceed = true
        mockWeather = nil
        mockError = nil
        fetchWeatherCallCount = 0
        lastRequestedCity = nil
    }
}

// MARK: - Mock Weather Data
extension MockWeatherService {
    static func createMockWeather(city: City, temperature: Double = 25.0) -> Weather {
        return Weather(
            city: city.rawValue,
            temperature: temperature,
            lastUpdated: Date()
        )
    }
    
    static func createMockWeatherResponse(city: String, temperature: Double) -> WeatherResponse {
        return WeatherResponse(
            main: Main(temp: temperature),
            name: city,
            dt: Date().timeIntervalSince1970
        )
    }
}
