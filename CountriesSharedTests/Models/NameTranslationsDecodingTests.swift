//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesSharedTestsHelpers
@testable import CountriesShared

final class NameTranslationsDecodingTests: XCTestCase, CodingTester {
    
    let expectedObject: NameTranslations = .random()
    let requiredFields: [String] = []
    
    func testFullDecoding() {
        performFullDecodingTest()
    }
    
    func testEncoding() {
        performFullEncodingTest()
    }

}
