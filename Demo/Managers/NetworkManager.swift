//
//  NetworkManager.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 15/01/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    var baseUrlString: String? = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
    
    private init() {}
    
    func fetchData() async throws -> [HoldingData] {
        guard let urlString = baseUrlString,
              let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decodedData = try JSONDecoder().decode(HoldingsResponse.self, from: data)
            // Save to UserDefaults
            saveToUserDefaults(userHolding: decodedData.data.userHolding)
            return decodedData.data.userHolding
        } catch {
            throw error
        }
    }
    
    private func saveToUserDefaults(userHolding: [HoldingData]) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(userHolding)
            UserDefaults.standard.set(encodedData, forKey: "userHolding")
        } catch {
            print("Failed to save userHolding to UserDefaults: \(error)")
        }
    }
    
    func loadFromUserDefaults() -> [HoldingData]? {
        guard let data = UserDefaults.standard.data(forKey: "userHolding") else { return nil }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode([HoldingData].self, from: data)
        } catch {
            print("Failed to decode userHolding from UserDefaults: \(error)")
            return nil
        }
    }
}
