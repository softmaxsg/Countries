//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class NameTranslationsDecodingTests: XCTestCase, DecodingTester {
    
    let expectedObject: NameTranslations = .random()
    let requiredFields: [String] = []
    
    func testFullDecoding() {
        performFullDecodingTest()
    }
    
}
