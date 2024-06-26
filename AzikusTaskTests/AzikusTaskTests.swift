//
//  AzikusTaskTests.swift
//  AzikusTaskTests
//
//  Created by Tin on 26.06.2024..
//

import XCTest
@testable import AzikusTask

final class AzikusTaskTests: XCTestCase {
    private var networkRequest: NetworkRequestsProtocol?
    private var networking: NetworkingProtocol?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkRequest = NetworkRequests.shared
        networking = Networking.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkRequest = nil
        networking = nil
    }
    
    /// Tests pagination to see whether it get the same elements
    func testIfElementsExist() {
        networkRequest?.fetchRepos(pageNumber: 1) { result in
            XCTAssertEqual(result, nil)
        }
    }
    
    /// Tests whether new elements are fetched for different page numbers
    func testDifferentPageElements() {
        networkRequest?.fetchRepos(pageNumber: 1) { [self] result1 in
            networkRequest?.fetchRepos(pageNumber: 2) { result2 in
                XCTAssertEqual(result1, result2)
            }
        }
    }
}
