//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class CountriesProviderTests: XCTestCase {

    private let expectedCountries: [Country] = .random(maxCount: 200) { .random() }
    private let expectedCountry = Country.random()
    
    func testLoadAllSuccessful() {
        let urlSession = mockedSessionAllCountries(result: .success(expectedCountries))
        let provider = CountriesProvider(urlSession: urlSession)
        let result = loadCountries(using: provider)
        XCTAssertEqual(result.value, expectedCountries)
    }
    
    func testLoadAllEmpty() {
        let urlSession = mockedSessionAllCountries(result: .success([]))
        let provider = CountriesProvider(urlSession: urlSession)
        let result = loadCountries(using: provider)
        XCTAssertEqual(result.value, [])
    }

    func testLoadAllFailed() {
        let urlSession = mockedSessionAllCountries(result: .failure(MockError.some))
        let provider = CountriesProvider(urlSession: urlSession)
        let result = loadCountries(using: provider)
        XCTAssertEqual(result.error as? MockError, MockError.some)
    }

    // This test proves that decoder is being used by CountriesProvider
    func testLoadAllDecodingFailed() {
        let jsonDecoder = JSONDecoderMock<[Country]> { _ in throw MockError.some }
        let urlSession = mockedSessionAllCountries(result: .success([]))
        let provider = CountriesProvider(urlSession: urlSession, jsonDecoder: jsonDecoder)
        let result = loadCountries(using: provider)
        XCTAssertEqual(result.error as? MockError, MockError.some)
    }
    
    func testLoadSuccessfull() {
        let urlSession = mockedSessionSingleCountry(code: expectedCountry.countryCode2, result: .success(expectedCountry))
        let provider = CountriesProvider(urlSession: urlSession)
        let result = loadCountry(code: expectedCountry.countryCode2, using: provider)
        XCTAssertEqual(result.value, expectedCountry)
    }

    func testLoadFailed() {
        let urlSession = mockedSessionSingleCountry(code: expectedCountry.countryCode2, result: .failure(MockError.some))
        let provider = CountriesProvider(urlSession: urlSession)
        let result = loadCountry(code: expectedCountry.countryCode2, using: provider)
        XCTAssertEqual(result.error as? MockError, MockError.some)
    }

    // This test proves that decoder is being used by CountriesProvider
    func testLoadDecodingFailed() {
        let jsonDecoder = JSONDecoderMock<Country> { _ in throw MockError.some }
        let urlSession = mockedSessionSingleCountry(code: expectedCountry.countryCode2, result: .success(.random()))
        let provider = CountriesProvider(urlSession: urlSession, jsonDecoder: jsonDecoder)
        let result = loadCountry(code: expectedCountry.countryCode2, using: provider)
        XCTAssertEqual(result.error as? MockError, MockError.some)
    }

}

extension CountriesProviderTests {
    
    private enum MockError: Error { case some }
    
    private func mockedSessionAllCountries(result: Result<[Country]>, file: StaticString = #file, line: UInt = #line) -> URLSessionProtocol {
        let serializedResult = result.map { countries in
            try! JSONSerialization.data(withJSONObject: countries.map { $0.JSON() })
        }

        return mockedSession(
            expectedUrl: URL(string: "https://restcountries.eu/rest/v2/all")!,
            resultStatusCode: result.value != nil ? 200 : 400,
            result: serializedResult,
            file: file,
            line: line
        )
    }
    
    private func mockedSessionSingleCountry(code: String, result: Result<Country>, file: StaticString = #file, line: UInt = #line) -> URLSessionProtocol {
        let serializedResult = result.map {
            try! JSONSerialization.data(withJSONObject: $0.JSON())
        }
        
        return mockedSession(
            expectedUrl: URL(string: String(format: "https://restcountries.eu/rest/v2/alpha/%@", code.lowercased()))!,
            resultStatusCode: result.value != nil ? 200 : 400,
            result: serializedResult,
            file: file,
            line: line
        )
    }

    private func loadCountries(using provider: CountriesProvider) -> Result<[Country]> {
        let expectation = self.expectation(description: "CountriesProvider")
        var result: Result<[Country]>!
        
        provider.loadAll {
            result = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        return result
    }
    
    private func loadCountry(code: String, using provider: CountriesProvider) -> Result<Country> {
        let expectation = self.expectation(description: "CountriesProvider")
        var result: Result<Country>!
        
        provider.load(with: code) {
            result = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        return result
    }

}
