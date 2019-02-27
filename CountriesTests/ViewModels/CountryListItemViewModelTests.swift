//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class CountryListItemViewModelTests: XCTestCase {

    func testInitialization() {
        let country = Country.random()
        let viewModel = CountryListItemViewModel(country: country)
        XCTAssertTrue(viewModel.isEqual(to: country))
    }
    
}
