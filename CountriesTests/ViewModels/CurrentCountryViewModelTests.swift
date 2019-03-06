//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
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

}
