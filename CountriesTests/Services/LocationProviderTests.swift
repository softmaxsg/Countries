//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Countries

final class LocationProviderTests: XCTestCase {

    private let expectedLocation = Location.random()
    private lazy var coreLocation = CLLocation(latitude: expectedLocation.coordinate.latitude, longitude: expectedLocation.coordinate.longitude)
    
    func testFullCycleSuccessfull() {
        let requestExpectation = self.expectation(description: "CLLocationManager.requestWhenInUseAuthorization")
        let startExpectation = self.expectation(description: "CLLocationManager.startMonitoringSignificantLocationChanges")
        let stopExpectation = self.expectation(description: "CLLocationManager.stopMonitoringSignificantLocationChanges")
        let locationExpectation = self.expectation(description: "LocationProviderDelegate.didUpdateLocation")

        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .notDetermined,
            requestWhenInUseAuthorization: {
                requestExpectation.fulfill()
                locationManager.notifyDidChangeAuthorization(.authorizedWhenInUse)
            },
            startMonitoringSignificantLocationChanges: {
                self.wait(for: [requestExpectation], timeout: 1)
                startExpectation.fulfill()
                locationManager.notifyDidUpdateLocations([self.coreLocation])
            },
            stopMonitoringSignificantLocationChanges: {
                stopExpectation.fulfill()
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
        
        var result: Location! = nil
        let delegate = mockedLocationProviderDelegate(
            didUpdateLocation: { _, location in
                result = location
                locationExpectation.fulfill()
            }
        )
        
        provider.startMonitoring(delegate: delegate)
        wait(for: [startExpectation, locationExpectation], timeout: 1)
        
        provider.stopMonitoring()
        wait(for: [stopExpectation], timeout: 1)
        
        XCTAssertEqual(result, expectedLocation)
    }

    func testGeocoderReturnsError() {
        let requestExpectation = self.expectation(description: "CLLocationManager.requestWhenInUseAuthorization")
        let startExpectation = self.expectation(description: "CLLocationManager.startMonitoringSignificantLocationChanges")
        let locationExpectation = self.expectation(description: "LocationProviderDelegate.didUpdateLocation")
        
        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .notDetermined,
            requestWhenInUseAuthorization: {
                requestExpectation.fulfill()
                locationManager.notifyDidChangeAuthorization(.authorizedWhenInUse)
            },
            startMonitoringSignificantLocationChanges: {
                self.wait(for: [requestExpectation], timeout: 1)
                startExpectation.fulfill()
                locationManager.notifyDidUpdateLocations([self.coreLocation])
            }
        )
        
        let countryGeocoder = mockedCountryGeocoder(result: .failure(MockError.some))
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: countryGeocoder
        )
        
        var result: Location! = nil
        let delegate = mockedLocationProviderDelegate(
            didUpdateLocation: { _, location in
                result = location
                locationExpectation.fulfill()
            }
        )
        
        provider.startMonitoring(delegate: delegate)
        wait(for: [startExpectation, locationExpectation], timeout: 1)
        
        XCTAssertEqual(result.coordinate, expectedLocation.coordinate)
        XCTAssertNil(result.countryCode)
    }

    func testStartMonitoringReturnsError() {
        let requestExpectation = self.expectation(description: "CLLocationManager.requestWhenInUseAuthorization")
        let startExpectation = self.expectation(description: "CLLocationManager.startMonitoringSignificantLocationChanges")
        let errorExpectation = self.expectation(description: "LocationProviderDelegate.didFailWithError")
        
        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .notDetermined,
            requestWhenInUseAuthorization: {
                requestExpectation.fulfill()
                locationManager.notifyDidChangeAuthorization(.authorizedWhenInUse)
            },
            startMonitoringSignificantLocationChanges: {
                self.wait(for: [requestExpectation], timeout: 1)
                startExpectation.fulfill()
                locationManager.notifyDidFailWithError(MockError.some)
            }
        )
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: emptyCountryGeocoder()
        )
        
        var resultError: Error! = nil
        let delegate = mockedLocationProviderDelegate(didFailWithError: { _, error in
            resultError = error
            errorExpectation.fulfill()
        })
        
        provider.startMonitoring(delegate: delegate)
        wait(for: [startExpectation, errorExpectation], timeout: 1)

        XCTAssertEqual(resultError as? MockError, MockError.some)
    }

    func testRequestAuthorizationFails() {
        let requestExpectation = self.expectation(description: "CLLocationManager.requestWhenInUseAuthorization")
        let errorExpectation = self.expectation(description: "LocationProviderDelegate.didFailWithError")
        
        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .notDetermined,
            requestWhenInUseAuthorization: {
                requestExpectation.fulfill()
                locationManager.notifyDidChangeAuthorization(.denied)
            }
        )
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: emptyCountryGeocoder()
        )
        
        var resultError: Error! = nil
        let delegate = mockedLocationProviderDelegate(didFailWithError: { _, error in
            resultError = error
            errorExpectation.fulfill()
        })
        
        provider.startMonitoring(delegate: delegate)
        wait(for: [requestExpectation, errorExpectation], timeout: 1)

        XCTAssertEqual((resultError as? CLError)?.code, CLError.denied)
    }

    func testAlreadyAuthorized() {
        let startExpectation = self.expectation(description: "CLLocationManager.startMonitoringSignificantLocationChanges")
        
        var locationManager: CLLocationManagerMock! = nil
        locationManager = mockedLocationManager(
            authorizationStatus: .authorizedWhenInUse,
            startMonitoringSignificantLocationChanges: {
                startExpectation.fulfill()
            }
        )
        
        let provider = LocationProvider(
            locationManager: locationManager,
            countryGeocoder: emptyCountryGeocoder()
        )
        
        let delegate = mockedLocationProviderDelegate()
        
        provider.startMonitoring(delegate: delegate)
        wait(for: [startExpectation], timeout: 1)
    }

}

extension LocationProviderTests {
    
    private enum MockError: Error { case some }
    
    private func mockedLocationManager(authorizationStatus: CLAuthorizationStatus,
                                       requestWhenInUseAuthorization: CLLocationManagerMock.MethodImpl? = nil,
                                       startMonitoringSignificantLocationChanges: CLLocationManagerMock.MethodImpl? = nil,
                                       stopMonitoringSignificantLocationChanges: CLLocationManagerMock.MethodImpl? = nil,
                                       file: StaticString = #file,
                                       line: UInt = #line) -> CLLocationManagerMock {
        return CLLocationManagerMock(
            authorizationStatus: { authorizationStatus  },
            requestWhenInUseAuthorization: requestWhenInUseAuthorization ?? { XCTFail("Should not be called", file: file, line: line) },
            startMonitoringSignificantLocationChanges: startMonitoringSignificantLocationChanges ?? { XCTFail("Should not be called", file: file, line: line) },
            stopMonitoringSignificantLocationChanges: stopMonitoringSignificantLocationChanges ?? { XCTFail("Should not be called", file: file, line: line) }
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

    private func mockedLocationProviderDelegate(didUpdateLocation: LocationProviderDelegateMock.DidUpdateLocationImpl? = nil,
                                                didFailWithError: LocationProviderDelegateMock.DidFailWithErrorImpl? = nil,
                                                file: StaticString = #file,
                                                line: UInt = #line) -> LocationProviderDelegateMock {
        return LocationProviderDelegateMock(
            didUpdateLocation: didUpdateLocation ?? { _, _ in XCTFail("Should not be called", file: file, line: line) },
            didFailWithError: didFailWithError ?? { _, _ in XCTFail("Should not be called", file: file, line: line) }
        )
    }

}
