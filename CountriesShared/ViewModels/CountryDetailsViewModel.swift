//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public protocol CountryDetailsViewModelProtocol: CountryBriefDetailsViewModelProtocol {
    
    var capital: String { get }
    var region: String { get }
    var regionalBlocs: String { get }
    var languages: String { get }
    var currencies: String { get }
    
}

public struct CountryDetailsViewModel: CountryDetailsViewModelProtocol {
    
    private let briefDetails: CountryBriefDetailsViewModel
    
    public var name: String { return briefDetails.name }
    public var population: String { return briefDetails.population }
    public var areaSize: String { return briefDetails.areaSize }
    public var flagUrl: URL { return briefDetails.flagUrl }
    
    public let capital: String
    public let region: String
    public let regionalBlocs: String
    public let languages: String
    public let currencies: String
    
    public init(country: Country) {
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
