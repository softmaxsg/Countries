//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class LanguageDecodingTests: XCTestCase, CodingTester {
    
    let expectedObject = Language.random()
    let optionalFields = [Language.CodingKeys.languageCode2.rawValue]
    lazy var requiredFields = Language.CodingKeys.allCases.map { $0.rawValue }.filter { !optionalFields.contains($0) }
    
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
