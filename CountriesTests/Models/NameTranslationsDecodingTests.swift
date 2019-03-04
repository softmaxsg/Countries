//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

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
