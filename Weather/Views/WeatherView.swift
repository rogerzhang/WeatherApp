import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            // Weather Content
            if let weather = viewModel.weather {
                VStack(spacing: 16) {
                    Text(weather.city)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("\(Int(weather.temperature))°C")
                        .font(.system(size: 72))
                        .fontWeight(.thin)
                    
                    Text("Last updated: \(weather.lastUpdated, formatter: dateFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else if viewModel.isLoading {
                ProgressView("Loading...")
                    .scaleEffect(1.5)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.red)
                    
                    Text("Error")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            // City Selector
            Picker("City", selection: $viewModel.selectedCity) {
                ForEach(City.allCases, id: \.self) { city in
                    Text(city.rawValue).tag(city)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.startTimer()
            viewModel.fetchWeather()
        }
        .onChange(of: viewModel.selectedCity) {
            viewModel.fetchWeather()
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter
}()
