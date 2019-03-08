//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CoreLocation
import CountriesSharedTestsHelpers
@testable import CountriesShared

final class LocationProviderTests: XCTestCase {

    private let expectedLocation = Location.random()
    private lazy var coreLocation = CLLocation(latitude: expectedLocation.coordinate.latitude, longitude: expectedLocation.coordinate.longitude)
    
    func testFullCycleSuccessfull() {
        let authorizationRequestExpectation = self.expectation(description: "CLLocationManager.requestWhenInUseAuthorization")
        let locationRequestExpectation = self.expectation(description: "CLLocationManager.requestLocation")

        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .notDetermined,
            requestWhenInUseAuthorization: {
                authorizationRequestExpectation.fulfill()
                locationManager.notifyDidChangeAuthorization(.authorizedWhenInUse)
            },
            requestLocation: {
                self.wait(for: [authorizationRequestExpectation], timeout: 1)
                locationRequestExpectation.fulfill()
                locationManager.notifyDidUpdateLocations([self.coreLocation])
            }
        )
        
        let countryGeocoder = mockedCountryGeocoder(
            expectedLocation: coreLocation,
            result: .success(expectedLocation.countryCode!)
        )
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: countryGeocoder
        )
        
        let result = requestLocation(provider)
        wait(for: [locationRequestExpectation], timeout: 1)

        XCTAssertEqual(result.value, expectedLocation)
    }

    func testGeocoderReturnsError() {
        let authorizationRequestExpectation = self.expectation(description: "CLLocationManager.requestWhenInUseAuthorization")
        let locationRequestExpectation = self.expectation(description: "CLLocationManager.requestLocation")
        
        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .notDetermined,
            requestWhenInUseAuthorization: {
                authorizationRequestExpectation.fulfill()
                locationManager.notifyDidChangeAuthorization(.authorizedWhenInUse)
            },
            requestLocation: {
                self.wait(for: [authorizationRequestExpectation], timeout: 1)
                locationRequestExpectation.fulfill()
                locationManager.notifyDidUpdateLocations([self.coreLocation])
            }
        )
        
        let countryGeocoder = mockedCountryGeocoder(result: .failure(MockError.some))
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: countryGeocoder
        )
        
        let result = requestLocation(provider)
        wait(for: [locationRequestExpectation], timeout: 1)
        
        XCTAssertEqual(result.value?.coordinate, expectedLocation.coordinate)
        XCTAssertNil(result.value?.countryCode)
    }

    func testStartMonitoringReturnsError() {
        let authorizationRequestExpectation = self.expectation(description: "CLLocationManager.requestWhenInUseAuthorization")
        let locationRequestExpectation = self.expectation(description: "CLLocationManager.requestLocation")
        
        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .notDetermined,
            requestWhenInUseAuthorization: {
                authorizationRequestExpectation.fulfill()
                locationManager.notifyDidChangeAuthorization(.authorizedWhenInUse)
            },
            requestLocation: {
                self.wait(for: [authorizationRequestExpectation], timeout: 1)
                locationRequestExpectation.fulfill()
                locationManager.notifyDidFailWithError(MockError.some)
            }
        )
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: emptyCountryGeocoder()
        )
        
        let result = requestLocation(provider)
        wait(for: [locationRequestExpectation], timeout: 1)

        XCTAssertEqual(result.error as? MockError, MockError.some)
    }

    func testRequestAuthorizationFails() {
        let authorizationRequestExpectation = self.expectation(description: "CLLocationManager.requestWhenInUseAuthorization")
        
        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .notDetermined,
            requestWhenInUseAuthorization: {
                authorizationRequestExpectation.fulfill()
                locationManager.notifyDidChangeAuthorization(.denied)
            }
        )
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: emptyCountryGeocoder()
        )
        
        let result = requestLocation(provider)
        wait(for: [authorizationRequestExpectation], timeout: 1)

        XCTAssertEqual((result.error as? CLError)?.code, CLError.denied)
    }

    func testAlreadyAuthorized() {
        let locationRequestExpectation = self.expectation(description: "CLLocationManager.requestLocation")
        
        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .authorizedWhenInUse,
            requestLocation: {
                locationRequestExpectation.fulfill()
            }
        )
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: emptyCountryGeocoder()
        )
        
        provider.requestLocation { _ in }
        wait(for: [locationRequestExpectation], timeout: 1)
    }

}

extension LocationProviderTests {
    
    private enum MockError: Error { case some }
    
    private func requestLocation(_ provider: LocationProviderProtocol) -> Result<Location> {
        let expectation = self.expectation(description: "LocationProvider.requestLocation")
        var result: Result<Location>! = nil
        
        provider.requestLocation {
            result = $0
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        return result
    }

    private func mockedLocationManager(authorizationStatus: CLAuthorizationStatus,
                                       requestWhenInUseAuthorization: CLLocationManagerMock.MethodImpl? = nil,
                                       requestLocation: CLLocationManagerMock.MethodImpl? = nil,
                                       stopMonitoringSignificantLocationChanges: CLLocationManagerMock.MethodImpl? = nil,
                                       file: StaticString = #file,
                                       line: UInt = #line) -> CLLocationManagerMock {
        return CLLocationManagerMock(
            authorizationStatus: { authorizationStatus  },
            requestWhenInUseAuthorization: requestWhenInUseAuthorization ?? { XCTFail("Should not be called", file: file, line: line) },
            requestLocation: requestLocation ?? { XCTFail("Should not be called", file: file, line: line) }
        )
    }
    
    private func emptyCountryGeocoder(file: StaticString = #file, line: UInt = #line) -> CountryGeocoderMock {
        return CountryGeocoderMock { _, _ in
            XCTFail("Should not be called", file: file, line: line)
        }
    }
    
    private func mockedCountryGeocoder(expectedLocation: CLLocation? = nil,
                                       result: Result<CountryCode>,
                                       file: StaticString = #file,
                                       line: UInt = #line) -> CountryGeocoderMock {
        return CountryGeocoderMock { location, handler in
            if let expectedLocation = expectedLocation {
                XCTAssertEqual(location, expectedLocation, file: file, line: line)
            }
            handler(result)
        }
    }

}
