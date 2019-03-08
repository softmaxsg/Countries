//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesShared
import CountriesSharedTestsHelpers
@testable import CountriesTodayWidgetViewModels

final class TodayCountryViewModelTests: XCTestCase {
 
    func testCleanInitialization() {
        let viewModel = TodayCountryViewModel(
            locationProvider: LocationProviderMock.empty,
            countryStorageService: CountryStorageServiceMock.empty,
            countriesProvider: CountriesProviderMock.empty
        )
        
        XCTAssertNil(viewModel.details)
    }
    
    func testUpdateCountryNewResult() {
        let expectedCountry = Country.random()
        let (viewModel, updateResult) = updateCountry(
            location: .success(Location(coordinate: .random(), countryCode: expectedCountry.countryCode2)),
            result: .success(expectedCountry)
        )
        
        XCTAssertEqual(updateResult, .new)
        XCTAssertTrue(viewModel.details?.isEqual(to: expectedCountry) ?? false)
    }
    
    func testUpdateCountrySameResult() {
        let expectedCountry = Country.random()
        let storageService = CountryStorageServiceMock(
            loadCountry: { return expectedCountry },
            saveCountry: { _ in }
        )

        let (viewModel, updateResult) = updateCountry(
            location: .success(Location(coordinate: .random(), countryCode: expectedCountry.countryCode2)),
            result: .failure(MockError.some), // CountriesProvider should not be used
            storageService: storageService
        )

        XCTAssertEqual(updateResult, .same)
        XCTAssertTrue(viewModel.details?.isEqual(to: expectedCountry) ?? false)
    }
    
    func testUpdateCountryLocationFailed() {
        let (viewModel, updateResult) = updateCountry(
            location: .failure(MockError.some),
            result: .success(.random())
        )
        
        XCTAssertEqual(updateResult, .error)
        XCTAssertNil(viewModel.details)
    }
    
    func testUpdateCountryInvalidLocation() {
        let (viewModel, updateResult) = updateCountry(
            location: .success(Location(coordinate: .random(), countryCode: nil)),
            result: .success(.random())
        )
        
        XCTAssertEqual(updateResult, .error)
        XCTAssertNil(viewModel.details)
    }
    
    func testUpdateCountryUnknownCountry() {
        let (viewModel, updateResult) = updateCountry(
            location: .success(.random()),
            result: .success(.random())
        )
        
        XCTAssertEqual(updateResult, .error)
        XCTAssertNil(viewModel.details)
    }

    func testUpdateCountryProviderFailed() {
        let (viewModel, updateResult) = updateCountry(
            location: .success(.random()),
            result: .failure(MockError.some)
        )
        
        XCTAssertEqual(updateResult, .error)
        XCTAssertNil(viewModel.details)
    }

    func testUpdateCountryUsesStorageService() {
        let initialCountry = Country.random()
        let expectedCountry = Country.random()
        
        var saveCountryCallsCount = 0
        let storageService = CountryStorageServiceMock(
            loadCountry: { return initialCountry },
            saveCountry: { country in
                saveCountryCallsCount += 1
                switch saveCountryCallsCount {
                case 1: XCTAssertEqual(country, initialCountry)
                case 2: XCTAssertEqual(country, expectedCountry)
                default: XCTFail("Called too many times")
                }
            }
        )
        
        _ = updateCountry(
            location: .success(Location(coordinate: .random(), countryCode: expectedCountry.countryCode2)),
            result: .success(expectedCountry),
            storageService: storageService
        )

        XCTAssertEqual(saveCountryCallsCount, 2)
    }
    
}

extension TodayCountryViewModelTests {
    
    enum MockError: Error { case some }
    
    func updateCountry(location: Result<Location>,
                       result: Result<Country>,
                       storageService: CountryStorageServiceProtocol = CountryStorageServiceMock.empty,
                       file: StaticString = #file,
                       line: UInt = #line) -> (TodayCountryViewModel, UpdateResult) {
        let locationProvider = LocationProviderMock { handler in
            handler(location)
        }
        
        let countriesProvider = CountriesProviderMock(
            loadAll: { _ in XCTFail("", file: file, line: line) },
            load: { code, handler in
                if code == result.value?.countryCode2 {
                    handler(result)
                } else {
                    handler(.failure(result.error ?? MockError.some))
                }
            }
        )
        
        let viewModel = TodayCountryViewModel(
            locationProvider: locationProvider,
            countryStorageService: storageService,
            countriesProvider: countriesProvider
        )
        
        var updateResult: UpdateResult!
        let expectation = self.expectation(description: "TodayCountryViewModel.updateCountry")
        viewModel.updateCountry {
            updateResult = $0
            expectation.fulfill()
        }
     
        wait(for: [expectation], timeout: 1)
        return (viewModel, updateResult)
    }
    
}
