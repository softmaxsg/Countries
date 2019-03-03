//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Countries

final class CountryGeocoderTests: XCTestCase {

    private var placemark: CLPlacemarkMock! = nil
    
    func testSuccessfulGeocoding() {
        let expectedLocation = CLLocation.random()
        let expectedCountryCode = CountryCode.random()
        
        let geocoder = CLGeocoderMock { location, handler in
            XCTAssertEqual(location, expectedLocation)

            // Test crashes if the placemark is accessed outside of the definition scope
            self.placemark = CLPlacemarkMock(location: location, isoCountryCode: expectedCountryCode)
            handler([self.placemark], nil)
        }

        let result = country(at: expectedLocation, geocoder: geocoder)
        XCTAssertEqual(result.value, expectedCountryCode)
    }

    func testFailedGeocoding() {
        let geocoder = CLGeocoderMock { _, handler in
            handler(nil, MockError.some)
        }
        
        let result = country(at: .random(), geocoder: geocoder)
        XCTAssertEqual(result.error as? MockError, MockError.some)
    }
    
    func testEmptyPlacemarks() {
        let geocoder = CLGeocoderMock { _, handler in
            handler([], nil)
        }
        
        let result = country(at: .random(), geocoder: geocoder)
        XCTAssertEqual(result.error as? CountryGeocoder.Error, CountryGeocoder.Error.unknown)
    }

}

extension CountryGeocoderTests {
    
    private enum MockError: Error { case some }
    
    private func country(at location: CLLocation, geocoder: CLGeocoderProtocol) -> Result<CountryCode> {
        let expectation = self.expectation(description: "CountryGeocoder")
        var result: Result<CountryCode>! = nil
        
        let countryGeocoder = CountryGeocoder(geocoder: geocoder)
        countryGeocoder.country(at: location) {
            result = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        return result
    }
    
}
