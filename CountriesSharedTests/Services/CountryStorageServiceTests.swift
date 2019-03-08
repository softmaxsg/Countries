//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesSharedTestsHelpers
@testable import CountriesShared

final class CountryStorageServiceTests: XCTestCase {

    private let storageKey = "CurrentCountry"
    
    func testLoadCountrySucceeded() {
        let expectedCountry = Country.random()
        let country = loadCountry(loadedData: .random(), decodedCountry: expectedCountry)
        XCTAssertEqual(country, expectedCountry)
    }
    
    func testLoadCountryFailed() {
        let country = loadCountry(loadedData: nil, decodedCountry: nil)
        XCTAssertNil(country)
    }
    
    func testLoadCountryDecodingFailed() {
        let country = loadCountry(loadedData: .random(), decodedCountry: nil)
        XCTAssertNil(country)
    }

    func testSaveCountry() {
        let expectedData = Data.random()
        let data = saveCountry(.random(), encodedData: expectedData)
        XCTAssertEqual(data, expectedData)
    }
    
    func testRemoveCountry() {
        let data = saveCountry(nil, encodedData: nil)
        XCTAssertNil(data)
    }
    
    func testSaveCountryEncodingFailed() {
        let data = saveCountry(.random(), encodedData: nil)
        XCTAssertNil(data)
    }

}


extension CountryStorageServiceTests {
    
    private enum MockError: Error { case some }
    
    private func loadCountry(loadedData: Data?, decodedCountry: Country?, file: StaticString = #file, line: UInt = #line) -> Country? {
        let userDefaults = UserDefaultsMock(
            getData: { key in
                XCTAssertEqual(key, self.storageKey)
                return loadedData
            },
            setValue: { _, _ in
                XCTFail("Should not be called")
            }
        )
        
        let jsonEncoder = JSONEncoderMock<Country> { _ in
            XCTFail("Should not be called")
            throw MockError.some
        }
        
        let jsonDecoder = JSONDecoderMock<Country> { data in
            XCTAssertEqual(data, loadedData)
            guard let decodedCountry = decodedCountry else { throw MockError.some }
            return decodedCountry
        }
        
        let service = CountryStorageService(
            userDefaults: userDefaults,
            jsonEncoder: jsonEncoder,
            jsonDecoder: jsonDecoder
        )
        
        return service.loadCountry()
    }
    
    private func saveCountry(_ country: Country?, encodedData: Data?, file: StaticString = #file, line: UInt = #line) -> Data? {
        var result: Data? = .random()
        
        let userDefaults = UserDefaultsMock(
            getData: { _ in
                XCTFail("Should not be called")
                return nil
            },
            setValue: { data, key in
                XCTAssertEqual(key, self.storageKey)
                result = data as? Data
            }
        )
        
        let jsonEncoder = JSONEncoderMock<Country> { value in
            XCTAssertEqual(value, country)
            guard let encodedData = encodedData else { throw MockError.some }
            return encodedData
        }
        
        let jsonDecoder = JSONDecoderMock<Country> { _ in
            XCTFail("Should not be called")
            throw MockError.some
        }
        
        let service = CountryStorageService(
            userDefaults: userDefaults,
            jsonEncoder: jsonEncoder,
            jsonDecoder: jsonDecoder
        )
        
        service.saveCountry(country)
        return result
    }

}
