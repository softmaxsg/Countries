//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
import CountriesSharedTestsHelpers
@testable import CountriesShared

final class CountryDetailsViewModelTests: XCTestCase {
    
    private let country = Country.random()
    
    func testInitializationBasicProperties() {
        let viewModel = CountryDetailsViewModel(country: country)
        
        // CountryBriefDetailsProtocol
        XCTAssertTrue(viewModel.isEqual(to: country))
        
        XCTAssertEqual(viewModel.capital, country.capital)
        XCTAssertEqual(viewModel.region , country.region)
    }
    
    func testInitializationLanguages() {
        let viewModel = CountryDetailsViewModel(country: country)
        
        let expectedLanguages = country.languages.map { "\($0.name) (\($0.nativeName))" }.joined(separator: ", ")
        XCTAssertEqual(viewModel.languages, expectedLanguages)
    }
    
    func testInitializationRegionalBlocs() {
        let viewModel = CountryDetailsViewModel(country: country)
        
        let expectedRegionalBlocs = country.regionalBlocs.map { "\($0.name) (\($0.acronym))" }.joined(separator: ", ")
        XCTAssertEqual(viewModel.regionalBlocs, expectedRegionalBlocs)
    }
    
    func testInitializationCurrenciesNormal() {
        let viewModel = CountryDetailsViewModel(country: country)
        let expectedCurrencies = country.currencies
            .map { "\($0.symbol!) - \($0.name!) (\($0.code!))" }
            .joined(separator: ", ")
        
        XCTAssertEqual(viewModel.currencies, expectedCurrencies)
    }
    
    func testInitializationCurrenciesWithoutSymbol() {
        let currency = Currency.random(symbol: nil)
        let country = Country.random(currencies: [currency])
        let viewModel = CountryDetailsViewModel(country: country)
        
        let expectedCurrencies = "\(currency.name!) (\(currency.code!))"
        XCTAssertEqual(viewModel.currencies, expectedCurrencies)
    }
    
    func testInitializationCurrenciesWithoutName() {
        let currency = Currency.random(name: nil)
        let country = Country.random(currencies: [currency])
        let viewModel = CountryDetailsViewModel(country: country)
        
        let expectedCurrencies = "\(currency.symbol!) (\(currency.code!))"
        XCTAssertEqual(viewModel.currencies, expectedCurrencies)
    }
    
    func testInitializationCurrenciesWithoutCode() {
        let currency = Currency.random(code: nil)
        let country = Country.random(currencies: [currency])
        let viewModel = CountryDetailsViewModel(country: country)
        
        let expectedCurrencies = "\(currency.symbol!) - \(currency.name!)"
        XCTAssertEqual(viewModel.currencies, expectedCurrencies)
    }
    
    func testInitializationCurrenciesWithNoneCode() {
        let currency = Currency.random(code: "(none)")
        let country = Country.random(currencies: [currency])
        let viewModel = CountryDetailsViewModel(country: country)
        
        let expectedCurrencies = "\(currency.symbol!) - \(currency.name!)"
        XCTAssertEqual(viewModel.currencies, expectedCurrencies)
    }
    
    func testInitializationCurrenciesInvalid() {
        let currency = Currency.random(code: nil, name: nil, symbol: nil)
        let country = Country.random(currencies: [currency])
        let viewModel = CountryDetailsViewModel(country: country)
        
        XCTAssertEqual(viewModel.currencies, "")
    }
    
}
