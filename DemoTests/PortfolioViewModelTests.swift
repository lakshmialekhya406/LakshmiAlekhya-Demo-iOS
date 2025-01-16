//
//  ProfileViewModelTests.swift
//  DemoTests
//
//  Created by Batchu Lakshmi Alekhya on 15/01/25.
//

import Foundation
import XCTest
@testable import Demo


class PortfolioViewModelTests: XCTestCase {
    var viewModel: PortfolioViewModel!
    
    @MainActor
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = PortfolioViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    @MainActor
    func testCurrentValue() {
        // Arrange: Set up mock data
        viewModel.holdings = [
            HoldingData(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 140, close: 145),
            HoldingData(symbol: "GOOGL", quantity: 5, ltp: 2800, avgPrice: 2700, close: 2750)
        ]
        viewModel.summariseData()
        // Act: Compute current value
        let currentValue = viewModel.currentValue

        // sum(quatity*ltp)
        // Assert: Verify the computed current value
        XCTAssertEqual(currentValue, (10 * 150) + (5 * 2800))
    }

    @MainActor
    func testTotalInvestment() {
        // Arrange: Set up mock data
        viewModel.holdings = [
            HoldingData(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 140, close: 145),
            HoldingData(symbol: "GOOGL", quantity: 5, ltp: 2800, avgPrice: 2700, close: 2750)
        ]
        viewModel.summariseData()
        
        // Act: Compute total investment
        let totalInvestment = viewModel.totalInvestment

        // sum(quatity*avgPrice)
        // Assert: Verify the computed total investment
        XCTAssertEqual(totalInvestment, (10 * 140) + (5 * 2700))
    }

    @MainActor
    func testTotalPNL() {
        // Arrange: Set up mock data
        viewModel.holdings = [
            HoldingData(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 140, close: 145),
            HoldingData(symbol: "GOOGL", quantity: 5, ltp: 2800, avgPrice: 2700, close: 2750)
        ]
        viewModel.summariseData()

        // Act: Compute total PNL
        let totalPNL = viewModel.totalPNL

        // Assert: Verify the computed total PNL
        let expectedPNL = ((10 * 150) + (5 * 2800)) - ((10 * 140) + (5 * 2700))
        XCTAssertEqual(totalPNL, Double(expectedPNL))
    }

    @MainActor
    func testTodaysPNL() {
        // Arrange: Set up mock data
        viewModel.holdings = [
            HoldingData(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 140, close: 145),
            HoldingData(symbol: "GOOGL", quantity: 5, ltp: 2800, avgPrice: 2700, close: 2750)
        ]
        viewModel.summariseData()
        
        // Act: Compute today's PNL
        let todaysPNL = viewModel.todaysPNL

        // Assert: Verify the computed today's PNL
        // sum((close-ltp)*quantity)
        let expectedPNL = (10 * (145 - 150)) + (5 * (2750 - 2800))
        XCTAssertEqual(todaysPNL, Double(expectedPNL))
    }
    
    func testLoaderHidesOnFetchingDataSuccess() async throws {
        let promise = expectation(description: "Loader hides on fetching data success")
        Task {
            await viewModel.fetchHoldings()
            let isLoading = false
            promise.fulfill()
        }
        await fulfillment(of: [promise], timeout: 50)
    }
    
    @MainActor
    func testLoaderHidesOnFetchingDataFailure() async throws {
        let promise = expectation(description: "Loader hides on fetching data failure")
        Task {
            viewModel.manager.baseUrlString = "invalidURL"
            await viewModel.fetchHoldings()
            let isLoading = false
            promise.fulfill()
        }
        await fulfillment(of: [promise], timeout: 50)
    }
    
}
