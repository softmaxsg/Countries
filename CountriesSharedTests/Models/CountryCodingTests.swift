//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesSharedTestsHelpers
@testable import CountriesShared

final class CountryCodingTests: XCTestCase, CodingTester {
    
    let expectedObject = Country.random()
    let optionalFields = [Country.CodingKeys.areaSize.rawValue]
    lazy var requiredFields = Country.CodingKeys.allCases.map { $0.rawValue }.filter { !optionalFields.contains($0) }
    
    func testFullDecoding() {
        performFullDecodingTest()
    }
    
    func testRequiredFields() {
        performRequiredFieldsTest()
    }
    
    func testOptionalFields() {
        performOptionalFieldsTest()
    }

    func testEncoding() {
        performFullEncodingTest()
    }

}
