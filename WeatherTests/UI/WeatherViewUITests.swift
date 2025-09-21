//
//  WeatherViewUITests.swift
//  WeatherTests
//
//  Created by roger on 2025/9/21.
//

import XCTest
import SwiftUI
@testable import Weather

@MainActor
final class WeatherViewUITests: XCTestCase {
    
    func testWeatherCardInitialization() throws {
        // Given
        let weather = Weather(
            city: "London",
            temperature: 25.0,
            lastUpdated: Date()
        )
        
        // When
        let weatherCard = WeatherCard(weather: weather)
        
        // Then
        XCTAssertNotNil(weatherCard)
    }
    
    func testLoadingCardInitialization() throws {
        // Given & When
        let loadingCard = LoadingCard()
        
        // Then
        XCTAssertNotNil(loadingCard)
    }
    
    func testErrorCardInitialization() throws {
        // Given
        let errorMessage = "Test error"
        let isNetworkAvailable = true
        let onRetry = {}
        
        // When
        let errorCard = ErrorCard(
            errorMessage: errorMessage,
            isNetworkAvailable: isNetworkAvailable,
            onRetry: onRetry
        )
        
        // Then
        XCTAssertNotNil(errorCard)
    }
    
    func testNetworkStatusCardInitialization() throws {
        // Given & When
        let networkStatusCard = NetworkStatusCard()
        
        // Then
        XCTAssertNotNil(networkStatusCard)
    }
    
    func testCitySelectorCardInitialization() throws {
        // Given
        let selectedCity = Binding<City>(get: { .london }, set: { _ in })
        
        // When
        let citySelectorCard = CitySelectorCard(selectedCity: selectedCity)
        
        // Then
        XCTAssertNotNil(citySelectorCard)
    }
}

// MARK: - Date Formatter Tests
final class DateFormatterTests: XCTestCase {
    
    func testDateFormatterConfiguration() throws {
        // Given
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        
        // When
        let testDate = Date(timeIntervalSince1970: 1640995200) // 2022-01-01 00:00:00 UTC
        let formattedString = formatter.string(from: testDate)
        
        // Then
        XCTAssertNotNil(formattedString)
        XCTAssertTrue(formattedString.contains(":"))
    }
    
    func testDateFormatterWithDifferentTimes() throws {
        // Given
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US")
        
        // When & Then
        let morningDate = Date(timeIntervalSince1970: 1640995200) // 00:00
        let afternoonDate = Date(timeIntervalSince1970: 1641038400) // 12:00
        let eveningDate = Date(timeIntervalSince1970: 1641072000) // 20:00 (8 PM)
        
        let morningString = formatter.string(from: morningDate)
        let afternoonString = formatter.string(from: afternoonDate)
        let eveningString = formatter.string(from: eveningDate)
        
        // Verify that we get different time strings
        XCTAssertNotEqual(morningString, afternoonString)
        XCTAssertNotEqual(afternoonString, eveningString)
        XCTAssertNotEqual(morningString, eveningString)
        
        // Verify that the strings are not empty
        XCTAssertFalse(morningString.isEmpty)
        XCTAssertFalse(afternoonString.isEmpty)
        XCTAssertFalse(eveningString.isEmpty)
    }
}

// MARK: - Color Scheme Tests
final class ColorSchemeTests: XCTestCase {
    
    func testColorAccessibility() throws {
        // Given
        let primaryColor = Color.primary
        let secondaryColor = Color.secondary
        let blueColor = Color.blue
        let redColor = Color.red
        
        // When & Then
        // These tests verify that colors can be created
        // In a real app, you'd test color contrast ratios
        XCTAssertNotNil(primaryColor)
        XCTAssertNotNil(secondaryColor)
        XCTAssertNotNil(blueColor)
        XCTAssertNotNil(redColor)
    }
    
    func testGradientCreation() throws {
        // Given
        let gradient = LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.1),
                Color.purple.opacity(0.05)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // When & Then
        XCTAssertNotNil(gradient)
    }
}
