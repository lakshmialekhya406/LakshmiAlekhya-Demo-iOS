//
//  HoldingsResponse.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 15/01/25.
//

import Foundation

struct HoldingsResponse: Codable  {
    let data: UserHolding
}

struct UserHolding: Codable {
    let userHolding: [HoldingData]
}

struct HoldingData: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}
