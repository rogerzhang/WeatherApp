import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var selectedCity: City = .london
    @Published var weather: Weather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let weatherService = WeatherService()
    private var timer: Timer?
    
    func fetchWeather() {
        isLoading = true
        errorMessage = nil
        
        weatherService.getWeather(for: selectedCity) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.weather = nil
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.fetchWeather()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
    }
}
