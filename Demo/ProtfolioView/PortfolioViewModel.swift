//
//  PortfolioVM.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 15/01/25.
//

import Foundation

@MainActor
class PortfolioViewModel: ObservableObject {
    @Published var holdings: [HoldingData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    var currentValue: Double = 0.0
    var totalInvestment: Double = 0.0
    var totalPNL: Double = 0.0
    var todaysPNL: Double = 0.0
    let manager = PortfolioManager.shared
    
    init() {
        fetchData()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchData),
            name: .networkReachable,
            object: nil
        )
    }
    
    // fetch holdings data
    @objc private func fetchData() {
        Task {
            await fetchHoldings()
        }
    }

    func fetchHoldings() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedHoldings = try await manager.fetchData()
            DispatchQueue.main.async {
                self.holdings = fetchedHoldings
                self.summariseData()
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                // loading previous stored data on error
                self.holdings = self.manager.loadFromUserDefaults() ?? []
                self.summariseData()
                self.isLoading = false
            }
        }
    }
    
    // computing values for summary view
    func summariseData() {
        currentValue = holdings.reduce(0) { $0 + ($1.ltp * Double($1.quantity)) }
        totalInvestment = holdings.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
        totalPNL = currentValue - totalInvestment
        todaysPNL = holdings.reduce(0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
    }
}
