//
//  NetworkManagerTests.swift
//  DemoTests
//
//  Created by Batchu Lakshmi Alekhya on 15/01/25.
//

import XCTest
@testable import Demo

class NetworkManagerTests: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUp() {
        super.setUp()
        networkManager = NetworkManager.shared
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
    
    func testFetchDataSuccessfully() async throws {
        let promise = expectation(description: "Data received")
        do {
            _ = try await networkManager.fetchData()
            promise.fulfill()
        } catch {
            // Assert error
            XCTFail("Data fetching failed")
        }
        await fulfillment(of: [promise], timeout: 50)
    }
    
    func testFetchDataWithInvalidURL() async {
        let promise = expectation(description: "Invalid url")
        // Set an invalid URL
        NetworkManager.shared.baseUrlString = "invalid_url"
        
        do {
            _ = try await networkManager.fetchData()
            XCTFail("Expected error for invalid URL, but succeeded")
        } catch {
            // Assert error
            promise.fulfill()
        }
        await fulfillment(of: [promise], timeout: 50)
    }
}
