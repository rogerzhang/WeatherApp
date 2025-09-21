//
//  TestConfiguration.swift
//  WeatherTests
//
//  Created by roger on 2025/9/21.
//

import Foundation
import XCTest
@testable import Weather

// MARK: - Test Constants
struct TestConstants {
    static let londonCoordinates = (lat: 51.5073359, lon: -0.12765)
    static let helsinkiCoordinates = (lat: 60.1674881, lon: 24.9427473)
    static let testTemperature = 25.0
    static let testCityName = "London"
    static let testTimeout: TimeInterval = 5.0
}

// MARK: - Test Helpers
class TestHelpers {
    
    static func createMockWeatherResponse(
        city: String = TestConstants.testCityName,
        temperature: Double = TestConstants.testTemperature
    ) -> WeatherResponse {
        return WeatherResponse(
            main: Main(temp: temperature),
            name: city,
            dt: Date().timeIntervalSince1970
        )
    }
    
    static func createMockWeather(
        city: City = .london,
        temperature: Double = TestConstants.testTemperature
    ) -> Weather {
        return Weather(
            city: city.rawValue,
            temperature: temperature,
            lastUpdated: Date()
        )
    }
    
    static func waitForAsyncOperation(
        timeout: TimeInterval = TestConstants.testTimeout,
        operation: @escaping () -> Void
    ) {
        let expectation = XCTestExpectation(description: "Async operation")
        DispatchQueue.main.async {
            operation()
            expectation.fulfill()
        }
        // Note: This method should be called from within a test method
        // The actual wait should be done in the test using XCTestCase.wait
    }
}

// MARK: - Test Data Factory
class TestDataFactory {
    
    static func createWeatherData(for city: City) -> Weather {
        let temperature = city == .london ? 25.0 : 15.0
        return Weather(
            city: city.rawValue,
            temperature: temperature,
            lastUpdated: Date()
        )
    }
    
    static func createErrorData() -> WeatherError {
        return WeatherError.networkError("Test network error")
    }
    
    static func createAllCities() -> [City] {
        return City.allCases
    }
}

// MARK: - Test Assertions
extension XCTestCase {
    
    func assertWeatherEqual(_ weather1: Weather, _ weather2: Weather) {
        XCTAssertEqual(weather1.city, weather2.city)
        XCTAssertEqual(weather1.temperature, weather2.temperature, accuracy: 0.01)
        // Note: lastUpdated might be different due to timing
    }
    
    func assertCityCoordinates(_ city: City, expectedLat: Double, expectedLon: Double) {
        let coordinates = city.coordinates
        XCTAssertEqual(coordinates.lat, expectedLat, accuracy: 0.0001)
        XCTAssertEqual(coordinates.lon, expectedLon, accuracy: 0.0001)
    }
    
    func assertTemperatureInRange(_ temperature: Double, min: Double = -50, max: Double = 60) {
        XCTAssertGreaterThanOrEqual(temperature, min)
        XCTAssertLessThanOrEqual(temperature, max)
    }
}
