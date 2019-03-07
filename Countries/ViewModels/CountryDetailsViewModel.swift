//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol CountryDetailsViewModelProtocol: CountryBriefDetailsViewModelProtocol {
    
    var capital: String { get }
    var region: String { get }
    var regionalBlocs: String { get }
    var languages: String { get }
    var currencies: String { get }
    
}

struct CountryDetailsViewModel: CountryDetailsViewModelProtocol {
    
    private let briefDetails: CountryBriefDetailsViewModel
    
    var name: String { return briefDetails.name }
    var population: String { return briefDetails.population }
    var areaSize: String { return briefDetails.areaSize }
    var flagUrl: URL { return briefDetails.flagUrl }
    
    let capital: String
    let region: String
    let regionalBlocs: String
    let languages: String
    let currencies: String
    
    init(country: Country) {
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
