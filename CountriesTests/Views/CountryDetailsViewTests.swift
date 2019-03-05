//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

final class CountryDetailsViewTests: CountryDetailsViewTestCase {
    
    private lazy var view: CountryDetailsView = {
        let view: CountryDetailsView = CountryDetailsView.load()!
        view.briefCountryView?.imageLoader = imageLoaderMock
        return view
    }()
    
    func testCompactAppearance() {
        let view = self.view
        view.isAdvancedDetailsVisible = false
        view.configure(with: CurrentCountryViewModel(delegate: CurrentCountryViewModelDelegateMock.empty, country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            population: countryPopulation,
            areaSize: countryAreaSize
        )))
        
        adjustSize(for: view)
        snapshotVerifyView(view)
    }
    
    func testExpandedAppearance() {
        let view = self.view
        view.isAdvancedDetailsVisible = true
        view.configure(with: CurrentCountryViewModel(delegate: CurrentCountryViewModelDelegateMock.empty, country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            capital: countryCapital,
            languages: countryLanguages,
            currencies: countryCurrencies,
            region: countryRegion,
            regionalBlocs: countryRegionalBlocs,
            population: countryPopulation,
            areaSize: countryAreaSize
        )))

        adjustSize(for: view)
        snapshotVerifyView(view)
    }
    
    func testExpandedAppearanceWithoutCapital() {
        let view = self.view
        view.isAdvancedDetailsVisible = true
        view.configure(with: CurrentCountryViewModel(delegate: CurrentCountryViewModelDelegateMock.empty, country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            capital: "",
            languages: countryLanguages,
            currencies: countryCurrencies,
            region: countryRegion,
            regionalBlocs: countryRegionalBlocs,
            population: countryPopulation,
            areaSize: countryAreaSize
            )))
        
        adjustSize(for: view)
        snapshotVerifyView(view)
    }
    
    func testExpandedAppearanceWithoutLanguages() {
        let view = self.view
        view.isAdvancedDetailsVisible = true
        view.configure(with: CurrentCountryViewModel(delegate: CurrentCountryViewModelDelegateMock.empty, country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            capital: countryCapital,
            languages: [],
            currencies: countryCurrencies,
            region: countryRegion,
            regionalBlocs: countryRegionalBlocs,
            population: countryPopulation,
            areaSize: countryAreaSize
            )))
        
        adjustSize(for: view)
        snapshotVerifyView(view)
    }
    
    func testExpandedAppearanceWithoutCurrencies() {
        let view = self.view
        view.isAdvancedDetailsVisible = true
        view.configure(with: CurrentCountryViewModel(delegate: CurrentCountryViewModelDelegateMock.empty, country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            capital: countryCapital,
            languages: countryLanguages,
            currencies: [],
            region: countryRegion,
            regionalBlocs: countryRegionalBlocs,
            population: countryPopulation,
            areaSize: countryAreaSize
            )))
        
        adjustSize(for: view)
        snapshotVerifyView(view)
    }
    
    func testExpandedAppearanceWithoutRegion() {
        let view = self.view
        view.isAdvancedDetailsVisible = true
        view.configure(with: CurrentCountryViewModel(delegate: CurrentCountryViewModelDelegateMock.empty, country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            capital: countryCapital,
            languages: countryLanguages,
            currencies: countryCurrencies,
            region: "",
            regionalBlocs: countryRegionalBlocs,
            population: countryPopulation,
            areaSize: countryAreaSize
            )))
        
        adjustSize(for: view)
        snapshotVerifyView(view)
    }
    
    func testExpandedAppearanceWithoutRegionalBlocs() {
        let view = self.view
        view.isAdvancedDetailsVisible = true
        view.configure(with: CurrentCountryViewModel(delegate: CurrentCountryViewModelDelegateMock.empty, country: .random(
            countryCode2: countryCode,
            name: countryName,
            nativeName: countryNativeName,
            capital: countryCapital,
            languages: countryLanguages,
            currencies: countryCurrencies,
            region: countryRegion,
            regionalBlocs: [],
            population: countryPopulation,
            areaSize: countryAreaSize
            )))
        
        adjustSize(for: view)
        snapshotVerifyView(view)
    }

}
