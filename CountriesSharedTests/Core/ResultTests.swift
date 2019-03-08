//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesSharedTestsHelpers
@testable import CountriesShared

class ResultTests: XCTestCase {

    enum MockError: Error { case some }

    func testInitializationWithSuccessValue() {
        let expectedValue = UUID.random()
        let result = Result(value: expectedValue)
        switch result {
        case .success(let value):
            XCTAssertEqual(value, expectedValue)
        default:
            XCTFail()
        }
    }
    
    func testInitializationWithFailureValue() {
        let result = Result<Void>(error: MockError.some)
        switch result {
        case .failure(let error as MockError):
            XCTAssertEqual(error, MockError.some)
        default:
            XCTFail()
        }
    }

    func testValueProperty() {
        let expectedValue = UUID.random()
        let result = Result.success(expectedValue)
        XCTAssertEqual(result.value, expectedValue)
    }
    
    func testErrorProperty() {
        let result = Result<Void>.failure(MockError.some)
        XCTAssertEqual(result.error as! MockError, MockError.some)
    }
    
    func testMapSuccessValue() {
        let initialValue = UUID.random()
        let expectedValue = String.random()

        let initialResult = Result(value: initialValue)
        let result = initialResult.map { value -> String in
            XCTAssertEqual(value, initialValue)
            return expectedValue
        }

        XCTAssertEqual(result.value, expectedValue)
    }
    
    func testMapFailureValue() {
        let initialResult = Result<Void>.failure(MockError.some)
        let result = initialResult.map { value -> String in
            XCTFail("Should not be called")
            return ""
        }

        XCTAssertEqual(result.error as! MockError, MockError.some)
    }
    
}
