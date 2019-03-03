//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class CountriesProviderTests: XCTestCase {

    private let expectedCountries: [Country] = .random(maxCount: 200) { .random() }
    
    func testLoadAllSuccessful() {
        let urlSession = mockedSession(result: .success(expectedCountries))
        let provider = CountriesProvider(urlSession: urlSession)
        let result = loadCountries(using: provider)
        XCTAssertEqual(result.value, expectedCountries)
    }
    
    func testLoadAllEmpty() {
        let urlSession = mockedSession(result: .success([]))
        let provider = CountriesProvider(urlSession: urlSession)
        let result = loadCountries(using: provider)
        XCTAssertEqual(result.value, [])
    }

    func testLoadAllFailed() {
        let urlSession = mockedSession(result: .failure(MockError.some))
        let provider = CountriesProvider(urlSession: urlSession)
        let result = loadCountries(using: provider)
        XCTAssertEqual(result.error as? MockError, MockError.some)
    }

    // This test proves that decoder is being used by CountriesProvider
    func testLoadAllDecodingFailed() {
        let jsonDecoder = JSONDecoderMock<[Country]> { _ in throw MockError.some }
        let urlSession = mockedSession(result: .success([]))
        let provider = CountriesProvider(urlSession: urlSession, jsonDecoder: jsonDecoder)
        let result = loadCountries(using: provider)
        XCTAssertEqual(result.error as? MockError, MockError.some)
    }
    
}

extension CountriesProviderTests {
    
    private enum MockError: Error { case some }
    
    private func mockedSession(result: Result<[Country]>, file: StaticString = #file, line: UInt = #line) -> URLSessionProtocol {
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
    
}
