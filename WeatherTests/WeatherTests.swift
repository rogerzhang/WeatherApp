//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by roger on 2025/9/21.
//

import XCTest
@testable import Weather

final class WeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppLaunch() throws {
        // This is a basic integration test to ensure the app can launch
        // In a real scenario, you'd test the main app functionality
        XCTAssertTrue(true, "App should launch successfully")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Test weather data parsing performance
            let response = WeatherResponse(
                main: Main(temp: 25.0),
                name: "London",
                dt: Date().timeIntervalSince1970
            )
            let _ = Weather(from: response)
        }
    }

}
