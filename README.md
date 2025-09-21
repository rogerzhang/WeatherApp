# Weather App

A SwiftUI-based weather application that displays real-time weather information for different cities.

## 🏗️ Architecture Pattern

This project follows **Clean Architecture** principles with clear separation of concerns:

```
Weather/
├── Core/
│   ├── Models/          # Data models and entities
│   ├── Adapters/        # External API adapters
│   └── UserCases/       # Business logic and services
├── ViewModels/          # Presentation layer logic
└── Views/              # SwiftUI views
```

### Architecture Layers:

- **Models**: `Weather`, `WeatherResponse`, `City` - Core data structures
- **Adapters**: `WeatherAPI` - External API integration using Moya
- **Use Cases**: `WeatherService` - Business logic for weather data fetching
- **ViewModels**: `WeatherViewModel` - Presentation logic with `@Published` properties
- **Views**: `WeatherView`, `ContentView` - SwiftUI user interface

## 🚀 Features

- **Real-time Weather Data**: Fetches current weather conditions from OpenWeatherMap API
- **Multi-city Support**: Switch between London and Helsinki
- **Auto-refresh**: Automatically updates weather data every minute
- **Smart Network Handling**: Automatically detects network availability and retries when connection is restored
- **Card-based UI**: Modern, friendly interface with rounded cards and subtle shadows
- **Error Handling**: Displays user-friendly error messages with retry options
- **Loading States**: Shows loading indicators during data fetching
- **Network Status**: Real-time network connectivity monitoring and user feedback
- **Responsive Design**: Adapts to different screen sizes with scrollable content

  ## Screen Recording

https://github.com/user-attachments/assets/cbb63726-f338-47cc-8a37-48b46b575173



## ⏰ Weather Refresh Mechanism

### Current Implementation:
- **Smart Timer**: App triggers weather API requests every 60 seconds (only when network is available)
- **Network-Aware**: Automatically pauses/resumes based on network connectivity
- **Local Time Display**: Shows the time when the app last fetched data (not server update time)
- **API Data**: Uses OpenWeatherMap API which typically updates every 10-15 minutes

### Refresh Flow:
```
Network Monitor → Timer (60s) → fetchWeather() → API Request → Update UI with local timestamp
```

### Network Handling:
- **Real-time Monitoring**: Uses `NWPathMonitor` to detect network status changes
- **Automatic Retry**: Immediately fetches data when network becomes available
- **Smart Timer**: Only runs when network is available, pauses when offline
- **User Feedback**: Shows network status and provides retry options

### Note on Server Timestamps:
The app currently uses local time for "Last updated" display instead of server timestamps because:
- OpenWeatherMap API doesn't update weather data every minute
- Server timestamps (`response.dt`) reflect when weather data was last updated on the server
- Using local time provides better user experience showing when the app last refreshed

### Future Enhancement:
Consider implementing server-side timestamp display by:
```swift
// Option 1: Show both times
Text("Data: \(weather.serverTime) | Refreshed: \(weather.lastUpdated)")

// Option 2: Use server time with refresh indicator
Text("Last updated: \(weather.serverTime) (refreshed every minute)")
```

## 🛠️ Dependencies

- **Moya**: Network abstraction layer for API calls
- **Network**: Real-time network connectivity monitoring
- **SwiftUI**: Modern declarative UI framework
- **Foundation**: Core system services and networking
- **ComposableArchitecture**: State management (available but not fully utilized)
- **RxSwift/RxRelay**: Reactive programming (available but not used in current implementation)

## 📱 Compilation & Setup

### Prerequisites:
- Xcode 13.0 or later
- iOS 13.0 or later
- CocoaPods installed

### Installation Steps:

1. **Clone the repository**:
   ```bash
   git clone <https://github.com/rogerzhang/WeatherApp.git>
   cd Weather
   ```

2. **Install dependencies**:
   ```bash
   pod install
   ```

3. **Open the workspace**:
   ```bash
   open Weather.xcworkspace
   ```

4. **Configure API Key**:
   - The app uses OpenWeatherMap API
   - API key is currently hardcoded in `WeatherAPI.swift`
   - For production, move the API key to a secure configuration file

5. **Build and Run**:
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Project Structure:
```
Weather.xcworkspace    # Main workspace file (use this, not .xcodeproj)
├── Weather/           # Main app target
│   ├── Core/Models/   # Data models (Weather, City, WeatherError)
│   ├── Adapters/      # API adapters (WeatherAPI)
│   ├── UseCases/      # Business logic (WeatherService)
│   ├── ViewModels/    # Presentation logic (WeatherViewModel)
│   └── Views/         # SwiftUI views (WeatherView)
├── WeatherTests/      # Comprehensive unit tests (30 tests)
│   ├── Models/        # Model tests (WeatherModelTests, WeatherErrorTests)
│   ├── ViewModels/    # ViewModel tests (WeatherViewModelTests, WeatherViewModelNetworkTests)
│   ├── Services/      # Service tests (WeatherServiceTests, WeatherAPITests)
│   ├── UI/           # UI component tests (WeatherViewUITests, ColorSchemeTests, DateFormatterTests)
│   ├── Mocks/        # Mock implementations (MockWeatherService)
│   └── TestConfiguration.swift  # Test utilities and constants
├── WeatherUITests/    # UI automation tests
└── Pods/             # CocoaPods dependencies
```

## 🔧 Configuration

### API Configuration:
- **Base URL**: `https://api.openweathermap.org/data/2.5`
- **Units**: Metric (Celsius)
- **Supported Cities**: London, Helsinki
- **API Key**: Currently embedded (consider using environment variables for production)

### Timer Configuration:
- **Refresh Interval**: 60 seconds
- **Network-aware**: Only runs when network is available
- **Auto-start**: Timer starts when view appears and network is available
- **Auto-pause**: Timer pauses when network is unavailable
- **Auto-resume**: Timer resumes when network becomes available

### UI Components:
- **WeatherCard**: Main weather display with temperature and city
- **LoadingCard**: Animated loading state with progress indicator
- **ErrorCard**: Error display with retry functionality
- **NetworkStatusCard**: Network connectivity status indicator
- **CitySelectorCard**: City selection interface

## 🧪 Testing

### Running Tests:
```bash
# All Tests
xcodebuild test -workspace Weather.xcworkspace -scheme Weather -destination 'platform=iOS Simulator,name=iPhone 16'

# Unit Tests Only
Cmd + U in Xcode

# Specific Test Suite
xcodebuild test -workspace Weather.xcworkspace -scheme Weather -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:WeatherTests
```

### Test Coverage:
**✅ 100% Test Pass Rate - All 30 tests passing**

#### Test Suites (30 tests total):
- **WeatherModelTests** (6 tests) - Model validation, equality, and City enum
- **WeatherViewModelTests** (8 tests) - State management, network handling, timer functionality
- **WeatherServiceTests** (4 tests) - Service layer functionality with mock data
- **WeatherAPITests** (6 tests) - API configuration and networking
- **WeatherViewUITests** (5 tests) - UI component initialization and rendering
- **WeatherViewModelNetworkTests** (2 tests) - Network status monitoring
- **WeatherErrorTests** (3 tests) - Error handling validation
- **DateFormatterTests** (2 tests) - Date formatting functionality
- **ColorSchemeTests** (2 tests) - UI color and gradient testing
- **WeatherServiceIntegrationTests** (1 test) - End-to-end service integration
- **WeatherTests** (2 tests) - Basic app functionality and performance

#### Test Features:
- **Mock Objects**: Comprehensive mock implementations for isolated testing
- **Network Simulation**: Tests both online and offline scenarios
- **UI Component Testing**: All UI cards and components tested
- **Error Scenarios**: Network errors, API failures, and edge cases
- **Performance Testing**: Weather data parsing performance validation
- **Integration Testing**: End-to-end service integration validation

## 📝 Development Notes

### Code Style:
- Follow Swift naming conventions
- Use English for all comments and documentation
- Implement proper error handling
- Use `@Published` properties for reactive UI updates

### Future Improvements:
- Add more cities and weather conditions
- Implement weather forecasts and hourly data
- Add location-based weather using Core Location
- Implement proper state management with ComposableArchitecture
- Implement offline caching with Core Data
- Add weather icons and animations
- Implement push notifications for weather alerts
- Add weather map integration
- Implement dark mode support
- Add UI automation tests for user interactions
- Implement snapshot testing for UI components
- Add accessibility testing and improvements

## 🐛 Known Issues

- API key is hardcoded (security concern)
- No offline data persistence
- Timer continues running even when app is backgrounded
- Limited weather data (only temperature and city name)

## ✨ Recent Updates

### v3.0 - Comprehensive Testing & Code Quality
- **✅ 100% Test Coverage**: All 30 unit tests passing with comprehensive coverage
- **Mock Testing**: Complete mock implementations for isolated testing
- **Error Handling Tests**: Comprehensive error scenario testing
- **UI Component Tests**: All UI cards and components thoroughly tested
- **Performance Testing**: Weather data parsing performance validation
- **Integration Testing**: End-to-end service integration validation
- **Code Quality**: Fixed all compilation warnings and deprecated syntax
- **Test Infrastructure**: Centralized test configuration and helper utilities

### v2.0 - Enhanced UI & Network Handling
- **Card-based Design**: Modern, friendly interface with rounded cards and shadows
- **Smart Network Handling**: Real-time network monitoring with automatic retry
- **Enhanced Error Handling**: Different error states for network vs. API issues
- **Improved UX**: Better loading states and user feedback
- **Responsive Design**: Scrollable content that adapts to different screen sizes

### v1.0 - Initial Release
- Basic weather display for London and Helsinki
- 60-second auto-refresh timer
- Simple error handling
- Basic SwiftUI interface

## 📄 License

This project is for educational purposes. Please ensure you have proper API keys and follow OpenWeatherMap's terms of service.
