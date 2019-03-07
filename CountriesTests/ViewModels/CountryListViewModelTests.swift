//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class CountryListViewModelTests: XCTestCase {

    private let initialCountries: [Country] = .random(maxCount: 200) { .random() }

    func testAllItems() {
        let viewModel = self.viewModel(with: .success(initialCountries))
        compareItems(in: viewModel, with: initialCountries)
    }

    func testEmptyList() {
        let viewModel = self.viewModel(with: .success([]))
        
        switch viewModel.currentState {
        case .data(let count): XCTAssertEqual(count, 0)
        default: XCTFail("Invalid state")
        }
        
    }
    
    func testLoadingFailed() {
        let viewModel = self.viewModel(with: .failure(MockError.some))
        
        switch viewModel.currentState {
        case .error(let message): XCTAssertEqual(message, MockError.some.localizedDescription)
        default: XCTFail("Invalid state")
        }
    }
    
    func testInvalidIndex() {
        let viewModel = self.viewModel(with: .success(initialCountries))
        
        XCTAssertThrowsError(try viewModel.item(at: initialCountries.count), "Has to throw an error") { error in
            XCTAssertEqual(error as? RandomAccessCollectionError, RandomAccessCollectionError.indexOutOfBounds)
        }
    }
    
    func testSorting() {
        let expectedLocation = Location.random()
        let expectedCountries = initialCountries.shuffled()
        let sortingService = SortingServiceMock { countries, coordinate in
            XCTAssertEqual(coordinate, expectedLocation.coordinate)
            XCTAssertEqual(countries, self.initialCountries)
            return expectedCountries
        }
        
        let viewModel = self.viewModel(
            with: .success(initialCountries),
            currentLocation: expectedLocation,
            sortingService: sortingService
        )
        
        compareItems(in: viewModel, with: expectedCountries)
    }
    
    func testFiltering() {
        let expectedFilteringText = String.random()
        let expectedCountries = initialCountries.filter { _ in .random() }

        var filteringServiceCalls = 0
        let filteringService = FilteringServiceMock { countries, text in
            filteringServiceCalls += 1

            XCTAssertEqual(countries, self.initialCountries)

            switch filteringServiceCalls {
            case 1:
                XCTAssertTrue(text.isEmpty)
                return countries
                
            case 2:
                XCTAssertEqual(text, expectedFilteringText)
                return expectedCountries
                
            default:
                XCTFail("Called too many times")
                return []
            }
        }

        let viewModel = self.viewModel(
            with: .success(initialCountries),
            filteringService: filteringService,
            actions: { viewModel in
                viewModel.filteringText = expectedFilteringText
                return 1
            }
        )
        
        compareItems(in: viewModel, with: expectedCountries)
    }
    
    func testCurrentCountryIsNotInList() {
        let expectedLocation = Location.random(countryCode: initialCountries.randomElement()!.countryCode2)
        let expectedCountries = initialCountries.filter { $0.countryCode2 != expectedLocation.countryCode }
        
        let viewModel = self.viewModel(
            with: .success(initialCountries),
            currentLocation: expectedLocation
        )
        
        compareItems(in: viewModel, with: expectedCountries)
    }
    
    func testCurrentCountry() {
        let currentCountryDidChangeExpectation = self.expectation(description: "CountryListViewModelDelegate.currentCountryDidChange")
        let currentCountryDidSaveExpectation = self.expectation(description: "CountryStorageService.saveCountry")

        let delegate = CountryListViewModelDelegateMock(
            stateDidChange: { },
            currentCountryDidChange: {
                XCTAssertTrue(OperationQueue.current! === OperationQueue.main, "Delegate method has to be called on the main thread")
                currentCountryDidChangeExpectation.fulfill()
            }
        )

        let expectedCountry = initialCountries.randomElement()!
        let expectedLocation = Location.random(countryCode: expectedCountry.countryCode2)
        
        let countryStorageService = CountryStorageServiceMock(
            loadCountry: { return nil },
            saveCountry: { country in
                XCTAssertEqual(country, expectedCountry)
                currentCountryDidSaveExpectation.fulfill()
            }
        )

        let viewModel = self.viewModel(
            with: .success(initialCountries),
            delegate: delegate,
            currentLocation: expectedLocation,
            countryStorageService: countryStorageService
        )
        
        wait(for: [currentCountryDidChangeExpectation, currentCountryDidSaveExpectation], timeout: 1)
        let currentCountry = viewModel.currentCountry(delegate: CurrentCountryViewModelDelegateMock.empty)
        
        // Only brief checking is performed here
        // Detailed testing of CurrentCountryViewModel is implemented separately
        XCTAssertTrue(currentCountry?.details.isEqual(to: expectedCountry) ?? false)
    }
    
}

extension CountryListViewModelTests {
    
    private enum MockError: Error { case some }
    
    private func mockedCountriesProvider(with result: Result<[Country]>, file: StaticString = #file, line: UInt = #line) -> CountriesProviderProtocol {
        return CountriesProviderMock(
            loadAll: { handler in
                OperationQueue.main.addOperation { handler(result) }
            },
            load: { _, _ in
                XCTFail("Should not be called", file: file, line: line)
            }
        )
    }
    
    private func viewModel(with result: Result<[Country]>,
                           delegate: CountryListViewModelDelegate? = nil,
                           currentLocation: Location? = nil,
                           sortingService: SortingServiceProtocol = SortingServiceMock.empty,
                           filteringService: FilteringServiceProtocol = FilteringServiceMock.empty,
                           countryStorageService: CountryStorageServiceProtocol = CountryStorageServiceMock.empty,
                           actions: ((CountryListViewModel) -> Int)? = nil,
                           file: StaticString = #file,
                           line: UInt = #line) -> CountryListViewModel {
        var stateDidChangeExpectation = self.expectation(description: "CountryListViewModelDelegate.stateDidChange")

        var viewModel: CountryListViewModel!
        
        let provider = mockedCountriesProvider(with: result, file: file, line: line)
        let defaultDelegate = CountryListViewModelDelegateMock(
            stateDidChange: {
                XCTAssertTrue(OperationQueue.current! === OperationQueue.main, "Delegate method has to be called on the main thread")
                switch viewModel.currentState {
                case .loading: return // Expectation should not be fulfilled in this case
                case .data: XCTAssertNotNil(result.value, file: file, line: line)
                case .error: XCTAssertNotNil(result.error, file: file, line: line)
                }
                stateDidChangeExpectation.fulfill()
            },
            currentCountryDidChange: {
                XCTAssertTrue(OperationQueue.current! === OperationQueue.main, "Delegate method has to be called on the main thread")
            }
        )

        var locationProvider: LocationProviderMock! = nil
        locationProvider = LocationProviderMock { handler in
            if let currentLocation = currentLocation {
                handler(.success(currentLocation))
            } else {
                handler(.failure(MockError.some))
            }
        }
        
        viewModel = CountryListViewModel(
            delegate: delegate ?? defaultDelegate,
            countriesProvider: provider,
            locationProvider: locationProvider,
            sortingService: sortingService,
            filteringService: filteringService,
            countryStorageService: countryStorageService
        )
        
        viewModel.loadCountries()
        
        if delegate != nil {
            stateDidChangeExpectation.fulfill()
        }
        
        wait(for: [stateDidChangeExpectation], timeout: 1)
        
        if let actions = actions {
            if delegate == nil {
                stateDidChangeExpectation = self.expectation(description: "CountryListViewModelDelegate.stateDidChange")
                stateDidChangeExpectation.expectedFulfillmentCount = actions(viewModel)
                wait(for: [stateDidChangeExpectation], timeout: 1)
            } else {
                _ = actions(viewModel)
            }
        }

        return viewModel
    }

    private func compareItems(in viewModel: CountryListViewModel, with countries: [Country], file: StaticString = #file, line: UInt = #line) {
        switch viewModel.currentState {
        case .data(let itemsCount):
            XCTAssertEqual(itemsCount, countries.count, "CountryListViewModel contains \(itemsCount) items but expected \(countries.count)", file: file, line: line)
        default:
            XCTFail("CountryListViewModel state is invalid", file: file, line: line)
        }
        
        for (index, country) in countries.enumerated() {
            let item = try! viewModel.item(at: index)
            XCTAssertTrue(item.isEqual(to: country), "CountryListItemViewModel at index \(index) does not match corresponding Country objct", file: file, line: line)
        }
    }

}
