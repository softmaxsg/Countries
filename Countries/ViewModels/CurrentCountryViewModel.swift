//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum CurrentCountryViewMode {
    
    case compact
    case expanded
    
}

protocol CurrentCountryViewModelDelegate: class {
    
    func viewModeDidChange()
    
}

protocol CurrentCountryViewModelProtocol: class, CountryDetailsProtocol {

    var viewMode: CurrentCountryViewMode { get set }
    
}

final class CurrentCountryViewModel: CurrentCountryViewModelProtocol {
    
    private let briefDetails: CountryBriefDetailsViewModel
    
    weak var delegate: CurrentCountryViewModelDelegate?
    
    var viewMode = CurrentCountryViewMode.compact { didSet { delegate?.viewModeDidChange() } }
    
    var name: String { return briefDetails.name }
    var population: String { return briefDetails.population }
    var areaSize: String { return briefDetails.areaSize }
    var flagUrl: URL { return briefDetails.flagUrl }

    let capital: String
    let region: String
    let regionalBlocs: String
    let languages: String
    let currencies: String

    init(delegate: CurrentCountryViewModelDelegate, country: Country) {
        self.delegate = delegate
        
        briefDetails = CountryBriefDetailsViewModel(country: country)
        
        capital = country.capital
        region = country.region

        languages = country.languages.map { $0.displayText }.joined(separator: ", ")
        regionalBlocs = country.regionalBlocs.map { $0.displayText }.joined(separator: ", ")
        currencies = country.currencies.compactMap { $0.displayText }.joined(separator: ", ")
    }
    
}

private extension Language {
    
    var displayText: String {
        return "\(name) (\(nativeName))"
    }
    
}

private extension RegionalBloc {
    
    var displayText: String {
        return "\(name) (\(acronym))"
    }
    
}

private extension Currency {

    var displayText: String? {
        let code = self.code.flatMap { code in
            code != "(none)" ? "(\(code))" : nil
        }
        
        var symbolAndName: String? = [symbol, name]
            .compactMap { $0 }
            .joined(separator: " - ")
        
        if symbolAndName?.isEmpty ?? true {
            symbolAndName = nil
        }

        let result = [symbolAndName, code]
            .compactMap { $0 }
            .joined(separator: " ")
        
        return !result.isEmpty ? result : nil
    }

}
