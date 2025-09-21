import Foundation
import SwiftUI
import Network

class WeatherViewModel: ObservableObject {
    @Published var selectedCity: City = .london
    @Published var weather: Weather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isNetworkAvailable = false
    
    private let weatherService:WeatherServiceProtocol = WeatherService()
    private var timer: Timer?
    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        setupNetworkMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let wasNetworkAvailable = self?.isNetworkAvailable ?? false
                self?.isNetworkAvailable = path.status == .satisfied
                
                // If network just became available and we don't have weather data, fetch immediately
                if !wasNetworkAvailable && self?.isNetworkAvailable == true {
                    if self?.weather == nil {
                        self?.fetchWeather()
                    }
                }
            }
        }
        networkMonitor.start(queue: networkQueue)
    }
    
    func fetchWeather() {
        // Don't fetch if network is not available
        guard isNetworkAvailable else {
            errorMessage = "No network connection available"
            return
        }
        
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
                    
                    // If it's a network error, we'll retry when network becomes available
                    if case .networkError = error {
                        // Network error - will retry automatically when network is restored
                    }
                }
            }
        }
    }
    
    func startTimer() {
        // Only start timer if we have network
        guard isNetworkAvailable else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.fetchWeather()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func retryFetch() {
        if isNetworkAvailable {
            fetchWeather()
        }
    }
    
    deinit {
        stopTimer()
        networkMonitor.cancel()
    }
}
