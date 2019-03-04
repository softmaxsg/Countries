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

}

extension CountryListViewModelTests {
    
    private enum MockError: Error { case some }
    
    private func mockedCountriesProvider(with result: Result<[Country]>) -> CountriesProviderProtocol {
        return CountriesProviderMock { handler in
            OperationQueue.main.addOperation { handler(result) }
        }
    }
    
    private func viewModel(with result: Result<[Country]>,
                           currentLocation: Location? = nil,
                           sortingService: SortingServiceProtocol = SortingServiceMock.empty,
                           filteringService: FilteringServiceProtocol = FilteringServiceMock.empty,
                           actions: ((CountryListViewModel) -> Int)? = nil,
                           file: StaticString = #file,
                           line: UInt = #line) -> CountryListViewModel {
        var expectation = self.expectation(description: "CountryListViewModel.loadCountries")
        
        var viewModel: CountryListViewModel!
        
        let provider = mockedCountriesProvider(with: result)
        let delegate = CountryListViewModelDelegateMock {
            XCTAssertTrue(OperationQueue.current! === OperationQueue.main, "Delegate method has to be called on the main thread")
            switch viewModel.currentState {
            case .loading: return // Expectation should not be fulfilled in this case
            case .data: XCTAssertNotNil(result.value, file: file, line: line)
            case .error: XCTAssertNotNil(result.error, file: file, line: line)
            }
            expectation.fulfill()
        }

        var locationProvider: LocationProviderMock! = nil
        locationProvider = LocationProviderMock(
            startMonitoring: { delegate in
                if let currentLocation = currentLocation {
                    delegate.locationProvider(locationProvider, didUpdateLocation: currentLocation)
                } else {
                    delegate.locationProvider(locationProvider, didFailWithError: MockError.some)
                }
            },
            stopMonitoring: { }
        )
        
        viewModel = CountryListViewModel(
            delegate: delegate,
            countriesProvider: provider,
            locationProvider: locationProvider,
            sortingService: sortingService,
            filteringService: filteringService
        )
        
        viewModel.loadCountries()
        wait(for: [expectation], timeout: 1)
        
        if let actions = actions {
            expectation = self.expectation(description: "CountryListViewModelDelegate.stateDidChange")
            expectation.expectedFulfillmentCount = actions(viewModel)
            wait(for: [expectation], timeout: 1)
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
