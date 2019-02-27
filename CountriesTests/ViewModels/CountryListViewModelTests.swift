//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class CountryListViewModelTests: XCTestCase {

    private let initialCountries = Array(1...Int.random(in: 1...200)).map { _ in Country.random() }

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

}

extension CountryListViewModelTests {
    
    private enum MockError: Error { case some }
    
    private func mockedCountriesProvider(with result: Result<[Country]>) -> CountriesProviderProtocol {
        return CountriesProviderMock { handler in
            OperationQueue.main.addOperation { handler(result) }
        }
    }
    
    private func viewModel(with result: Result<[Country]>, file: StaticString = #file, line: UInt = #line) -> CountryListViewModel {
        let expectation = self.expectation(description: "CountryListViewModel.loadCountries")
        
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
        
        viewModel = CountryListViewModel(delegate: delegate, countriesProvider: provider)
        
        viewModel.loadCountries()
        wait(for: [expectation], timeout: 1)
        
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
