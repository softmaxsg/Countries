//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesShared
import CountriesSharedTestsHelpers
@testable import Countries

final class CurrentCountryViewModelTests: XCTestCase {

    func testViewMode() {
        let expectation = self.expectation(description: "CurrentCountryViewModelDelegate")
        let delegate = CurrentCountryViewModelDelegateMock {
            expectation.fulfill()
        }
        
        let viewModel = CurrentCountryViewModel(delegate: delegate, country: .random())
        XCTAssertEqual(viewModel.viewMode, .compact)
        
        viewModel.viewMode = .expanded
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(viewModel.viewMode, .expanded)
    }
    
    func testCountryDetails() {
        let expectedCountry = Country.random()
        let viewModel = CurrentCountryViewModel(delegate: CurrentCountryViewModelDelegateMock.empty, country: expectedCountry)
        XCTAssertTrue(viewModel.details.isEqual(to: expectedCountry))
    }

}
