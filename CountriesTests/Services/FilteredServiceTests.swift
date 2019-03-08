//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesShared
import CountriesSharedTestsHelpers
@testable import Countries

final class FilteredServiceTests: XCTestCase {
    
    private let filteringText = String.random()
    
    func testFilterByCountryCode2() {
        testFilter(using: filteringText, expectedResult: [
            Country.random(countryCode2: String.random().randomlyInserted(filteringText)),
            Country.random(countryCode2: String.random().randomlyInserted(filteringText)),
        ])
    }
    
    func testFilterByCountryCode3() {
        testFilter(using: filteringText, expectedResult: [
            Country.random(countryCode3: String.random().randomlyInserted(filteringText)),
            Country.random(countryCode3: String.random().randomlyInserted(filteringText)),
        ])
    }
    
    func testFilterByName() {
        testFilter(using: filteringText, expectedResult: [
            Country.random(name: String.random().randomlyInserted(filteringText)),
            Country.random(name: String.random().randomlyInserted(filteringText)),
        ])
    }

    func testFilterByNativeName() {
        testFilter(using: filteringText, expectedResult: [
            Country.random(nativeName: String.random().randomlyInserted(filteringText)),
            Country.random(nativeName: String.random().randomlyInserted(filteringText)),
        ])
    }
    
    func testFilterByCapital() {
        testFilter(using: filteringText, expectedResult: [
            Country.random(capital: String.random().randomlyInserted(filteringText)),
            Country.random(capital: String.random().randomlyInserted(filteringText)),
        ])
    }

    func testFilterByAlternativeSpellings() {
        let randomAlternativeSpellings = { () -> [String] in
            let array: [String] = .random(maxCount: 10) { .random() }
            let matchingSpelling = String.random().randomlyInserted(self.filteringText)
            return array.randomlyInserted([matchingSpelling])
        }
        
        testFilter(using: filteringText, expectedResult: [
            Country.random(alternativeSpellings: randomAlternativeSpellings()),
            Country.random(alternativeSpellings: randomAlternativeSpellings()),
        ])
    }

    func testFilterByNameTranslations() {
        let randomNameTranslations = { () -> NameTranslations in
            let translations = Array
                .random(maxCount: 10) { () -> (String, String) in (.random(), .random()) }
                .randomlyInserted([(.random(), String.random().randomlyInserted(self.filteringText))])
            return NameTranslations(translations: Dictionary(uniqueKeysWithValues: translations))
        }
        
        testFilter(using: filteringText, expectedResult: [
            Country.random(nameTranslations: randomNameTranslations()),
            Country.random(nameTranslations: randomNameTranslations()),
        ])
    }

    func testFilterByLanguage() {
        testFilter(using: filteringText, expectedResult: [
            Country.random(languages: [.random(languageCode2: String.random().randomlyInserted(filteringText))]),
            Country.random(languages: [.random(languageCode3: String.random().randomlyInserted(filteringText))]),
            Country.random(languages: [.random(name: String.random().randomlyInserted(filteringText))]),
            Country.random(languages: [.random(nativeName: String.random().randomlyInserted(filteringText))]),
        ])
    }

    func testFilterUsingEmptyText() {
        let initialCountries: [Country] = [.random(), .random(), .random()]
        let service = FilteringService()
        let result = service.filtered(initialCountries, using: "")
        XCTAssertEqual(result, initialCountries)
    }
    
}

extension FilteredServiceTests {
    
    private func testFilter(using text: String, expectedResult: [Country], file: StaticString = #file, line: UInt = #line) {
        let initialCountries: [Country] = Array
            .random(minCount: expectedResult.count, maxCount: max(10, expectedResult.count)) { .random() }
            .randomlyInsertedElements(expectedResult)

        let service = FilteringService()
        let result = service.filtered(initialCountries, using: text)
        XCTAssertEqual(result, expectedResult, file: file, line: line)
    }
    
}
