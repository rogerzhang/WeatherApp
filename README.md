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
- **Error Handling**: Displays user-friendly error messages
- **Loading States**: Shows loading indicators during data fetching
- **Clean UI**: Modern SwiftUI interface with temperature display and city selection

## ⏰ Weather Refresh Mechanism

### Current Implementation:
- **Client-side Timer**: App triggers weather API requests every 60 seconds
- **Local Time Display**: Shows the time when the app last fetched data (not server update time)
- **API Data**: Uses OpenWeatherMap API which typically updates every 10-15 minutes

### Refresh Flow:
```
Timer (60s) → fetchWeather() → API Request → Update UI with local timestamp
```

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
- **ComposableArchitecture**: State management (currently not fully utilized)
- **RxSwift/RxRelay**: Reactive programming (available but not used in current implementation)

## 📱 Compilation & Setup

### Prerequisites:
- Xcode 13.0 or later
- iOS 13.0 or later
- CocoaPods installed

### Installation Steps:

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
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
├── WeatherTests/      # Unit tests
├── WeatherUITests/    # UI tests
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
- **Auto-start**: Timer starts when view appears
- **Auto-stop**: Timer stops when view disappears

## 🧪 Testing

### Running Tests:
```bash
# Unit Tests
Cmd + U

# UI Tests
Select WeatherUITests scheme and run
```

### Test Coverage:
- Unit tests for WeatherService
- UI tests for weather display and city switching
- Error handling scenarios

## 📝 Development Notes

### Code Style:
- Follow Swift naming conventions
- Use English for all comments and documentation
- Implement proper error handling
- Use `@Published` properties for reactive UI updates

### Future Improvements:
- Add more cities
- Implement weather forecasts
- Add location-based weather
- Implement proper state management with ComposableArchitecture
- Add unit tests for ViewModels
- Implement offline caching
- Add weather icons and animations

## 🐛 Known Issues

- API key is hardcoded (security concern)
- Limited error handling for network failures
- No offline data persistence
- Timer continues running even when app is backgrounded

## 📄 License

This project is for educational purposes. Please ensure you have proper API keys and follow OpenWeatherMap's terms of service.
