//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest

protocol CodingTester {
    
    associatedtype Object: Decodable, Equatable
    
    var expectedObject: Object { get }
    var fullJSON: [String: Any] { get }
    var requiredFields: [String] { get }
    var optionalFields: [String] { get }
}

extension CodingTester {
    
    var optionalFields: [String] { return [] }
    
}

extension CodingTester where Object: JSONPresentable {
    
    var fullJSON: [String: Any] {
        return expectedObject.JSON()
    }
    
}

extension CodingTester {
    
    func performFullDecodingTest(file: StaticString = #file, line: UInt = #line) {
        let decodedObject = try? JSONDecoder().decode(Object.self, from: fullJSON)
        XCTAssertNotNil(decodedObject, file: file, line: line)
        XCTAssertEqual(decodedObject!, expectedObject, file: file, line: line)
    }
    
    func performRequiredFieldsTest(file: StaticString = #file, line: UInt = #line) {
        requiredFields.forEach { field in
            let currentJSON = fullJSON.removingValue(forKey: field)
            let decodedObject = try? JSONDecoder().decode(Object.self, from: currentJSON)
            XCTAssertNil(decodedObject, "Field `\(field)` has to be required", file: file, line: line)
        }
    }

    func performOptionalFieldsTest(file: StaticString = #file, line: UInt = #line) {
        optionalFields.forEach { field in
            let currentJSON = fullJSON.removingValue(forKey: field)
            let decodedObject = try? JSONDecoder().decode(Object.self, from: currentJSON)
            XCTAssertNotNil(decodedObject, "Field `\(field)` is optional", file: file, line: line)
        }
    }

}

extension CodingTester where Object: Encodable  {
    
    func performFullEncodingTest(file: StaticString = #file, line: UInt = #line) {
        let expectedJSON = fullJSON as NSDictionary
        let decodedJSON = try! JSONEncoder().encodeToJSON(expectedObject) as NSDictionary
        XCTAssertEqual(decodedJSON, expectedJSON, file: file, line: line)
    }
    
}
