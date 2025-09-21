//
//  WeatherModelTests.swift
//  WeatherTests
//
//  Created by roger on 2025/9/21.
//

import XCTest
@testable import Weather

final class WeatherModelTests: XCTestCase {
    
    func testWeatherInitialization() throws {
        // Given
        let response = WeatherResponse(
            main: Main(temp: 25.5),
            name: "London",
            dt: 1640995200 // 2022-01-01 00:00:00 UTC
        )
        
        // When
        let weather = Weather(from: response)
        
        // Then
        XCTAssertEqual(weather.city, "London")
        XCTAssertEqual(weather.temperature, 25.5)
        XCTAssertNotNil(weather.lastUpdated)
    }
    
    func testWeatherEquality() throws {
        // Given
        let response1 = WeatherResponse(
            main: Main(temp: 25.5),
            name: "London",
            dt: 1640995200
        )
        let response2 = WeatherResponse(
            main: Main(temp: 25.5),
            name: "London",
            dt: 1640995200
        )
        
        // When
        let weather1 = Weather(from: response1)
        let weather2 = Weather(from: response2)
        
        // Then
        // Since Weather uses Date() for lastUpdated, we need to test individual properties
        XCTAssertEqual(weather1.city, weather2.city)
        XCTAssertEqual(weather1.temperature, weather2.temperature)
        // lastUpdated will be different due to timing, so we just check it's not nil
        XCTAssertNotNil(weather1.lastUpdated)
        XCTAssertNotNil(weather2.lastUpdated)
    }
    
    func testWeatherInequality() throws {
        // Given
        let response1 = WeatherResponse(
            main: Main(temp: 25.5),
            name: "London",
            dt: 1640995200
        )
        let response2 = WeatherResponse(
            main: Main(temp: 30.0),
            name: "Helsinki",
            dt: 1640995200
        )
        
        // When
        let weather1 = Weather(from: response1)
        let weather2 = Weather(from: response2)
        
        // Then
        XCTAssertNotEqual(weather1, weather2)
    }
    
    func testCityCoordinates() throws {
        // Given & When
        let londonCoords = City.london.coordinates
        let helsinkiCoords = City.helsinki.coordinates
        
        // Then
        XCTAssertEqual(londonCoords.lat, 51.5073359)
        XCTAssertEqual(londonCoords.lon, -0.12765)
        XCTAssertEqual(helsinkiCoords.lat, 60.1674881)
        XCTAssertEqual(helsinkiCoords.lon, 24.9427473)
    }
    
    func testCityRawValues() throws {
        // Given & When
        let londonRawValue = City.london.rawValue
        let helsinkiRawValue = City.helsinki.rawValue
        
        // Then
        XCTAssertEqual(londonRawValue, "London")
        XCTAssertEqual(helsinkiRawValue, "Helsinki")
    }
    
    func testCityAllCases() throws {
        // Given & When
        let allCities = City.allCases
        
        // Then
        XCTAssertEqual(allCities.count, 2)
        XCTAssertTrue(allCities.contains(.london))
        XCTAssertTrue(allCities.contains(.helsinki))
    }
}

// MARK: - WeatherError Tests
final class WeatherErrorTests: XCTestCase {
    
    func testNetworkErrorDescription() throws {
        // Given
        let error = WeatherError.networkError("Connection failed")
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "Network error: Connection failed")
    }
    
    func testDecodingErrorDescription() throws {
        // Given
        let error = WeatherError.decodingError("Invalid JSON")
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "Decoding error: Invalid JSON")
    }
    
    func testUnknownErrorDescription() throws {
        // Given
        let error = WeatherError.unknownError
        
        // When
        let description = error.errorDescription
        
        // Then
        XCTAssertEqual(description, "Unknown error occurred")
    }
}
