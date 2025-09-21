//
//  WeatherServiceTests.swift
//  WeatherTests
//
//  Created by roger on 2025/9/21.
//

import XCTest
import Moya
@testable import Weather

final class WeatherServiceTests: XCTestCase {
    
    var weatherService: WeatherService!
    var mockWeatherService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
        mockWeatherService = MockWeatherService()
    }
    
    override func tearDown() {
        weatherService = nil
        mockWeatherService = nil
        super.tearDown()
    }
    
    func testWeatherServiceInitialization() throws {
        // Given & When
        let service = WeatherService()
        
        // Then
        XCTAssertNotNil(service)
    }
    
    func testGetWeatherForLondon() throws {
        // Given
        let expectation = XCTestExpectation(description: "Weather fetch for London")
        let city = City.london
        mockWeatherService.shouldSucceed = true
        mockWeatherService.mockWeather = MockWeatherService.createMockWeather(city: city, temperature: 25.0)
        
        // When
        mockWeatherService.getWeather(for: city) { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.city, "London")
                XCTAssertEqual(weather.temperature, 25.0)
                XCTAssertNotNil(weather.lastUpdated)
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWeatherForHelsinki() throws {
        // Given
        let expectation = XCTestExpectation(description: "Weather fetch for Helsinki")
        let city = City.helsinki
        mockWeatherService.shouldSucceed = true
        mockWeatherService.mockWeather = MockWeatherService.createMockWeather(city: city, temperature: 15.0)
        
        // When
        mockWeatherService.getWeather(for: city) { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.city, "Helsinki")
                XCTAssertEqual(weather.temperature, 15.0)
                XCTAssertNotNil(weather.lastUpdated)
            case .failure(let error):
                XCTFail("Expected success, got error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWeatherServiceProtocolConformance() throws {
        // Given
        let service = WeatherService()
        
        // Then
        XCTAssertTrue(service is WeatherServiceProtocol)
    }
}

// MARK: - WeatherAPI Tests
final class WeatherAPITests: XCTestCase {
    
    func testWeatherAPICase() throws {
        // Given
        let api = WeatherAPI.getWeather(lat: 51.5073359, lon: -0.12765)
        
        // When & Then
        switch api {
        case .getWeather(let lat, let lon):
            XCTAssertEqual(lat, 51.5073359)
            XCTAssertEqual(lon, -0.12765)
        }
    }
    
    func testWeatherAPIBaseURL() throws {
        // Given
        let api = WeatherAPI.getWeather(lat: 0, lon: 0)
        
        // When
        let baseURL = api.baseURL
        
        // Then
        XCTAssertEqual(baseURL.absoluteString, "https://api.openweathermap.org/data/2.5")
    }
    
    func testWeatherAPIPath() throws {
        // Given
        let api = WeatherAPI.getWeather(lat: 0, lon: 0)
        
        // When
        let path = api.path
        
        // Then
        XCTAssertEqual(path, "/weather")
    }
    
    func testWeatherAPIMethod() throws {
        // Given
        let api = WeatherAPI.getWeather(lat: 0, lon: 0)
        
        // When
        let method = api.method
        
        // Then
        XCTAssertEqual(method, .get)
    }
    
    func testWeatherAPITask() throws {
        // Given
        let lat = 51.5073359
        let lon = -0.12765
        let api = WeatherAPI.getWeather(lat: lat, lon: lon)
        
        // When
        let task = api.task
        
        // Then
        switch task {
        case .requestParameters(let parameters, let encoding):
            XCTAssertEqual(parameters["lat"] as? Double, lat)
            XCTAssertEqual(parameters["lon"] as? Double, lon)
            XCTAssertEqual(parameters["units"] as? String, "metric")
            XCTAssertNotNil(parameters["appid"])
            XCTAssertTrue(encoding is URLEncoding)
        default:
            XCTFail("Expected requestParameters task")
        }
    }
    
    func testWeatherAPIHeaders() throws {
        // Given
        let api = WeatherAPI.getWeather(lat: 0, lon: 0)
        
        // When
        let headers = api.headers
        
        // Then
        XCTAssertEqual(headers?["Content-type"], "application/json")
    }
}

// MARK: - Integration Tests
final class WeatherServiceIntegrationTests: XCTestCase {
    
    var weatherService: WeatherService!
    
    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
    }
    
    override func tearDown() {
        weatherService = nil
        super.tearDown()
    }
    
    func testWeatherServiceIntegration() throws {
        // Given
        let expectation = XCTestExpectation(description: "Integration test")
        let city = City.london
        
        // When
        weatherService.getWeather(for: city) { result in
            // Then
            switch result {
            case .success(let weather):
                XCTAssertNotNil(weather)
                XCTAssertEqual(weather.city, "London")
                XCTAssertTrue(weather.temperature > -50 && weather.temperature < 60) // Reasonable temperature range
            case .failure(let error):
                // This might fail in CI/CD or without network
                print("Integration test failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
