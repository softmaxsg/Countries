//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public struct Country: Equatable {
    
    public let countryCode2: String
    public let countryCode3: String
    public let name: String
    public let nativeName: String
    public let alternativeSpellings: [String]
    public let nameTranslations: NameTranslations
    public let capital: String
    public let languages: [Language]
    public let currencies: [Currency]
    public let region: String
    public let regionalBlocs: [RegionalBloc]
    public let population: UInt64
    public let areaSize: Double?
    public let center: Coordinate
    
    public init(countryCode2: String,
                countryCode3: String,
                name: String,
                nativeName: String,
                alternativeSpellings: [String],
                nameTranslations: NameTranslations,
                capital: String,
                languages: [Language],
                currencies: [Currency],
                region: String,
                regionalBlocs: [RegionalBloc],
                population: UInt64,
                areaSize: Double?,
                center: Coordinate) {
        self.countryCode2 = countryCode2
        self.countryCode3 = countryCode3
        self.name = name
        self.nativeName = nativeName
        self.alternativeSpellings = alternativeSpellings
        self.nameTranslations = nameTranslations
        self.capital = capital
        self.languages = languages
        self.currencies = currencies
        self.region = region
        self.regionalBlocs = regionalBlocs
        self.population = population
        self.areaSize = areaSize
        self.center = center
    }
    
}

extension Country: Codable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case countryCode2 = "alpha2Code"
        case countryCode3 = "alpha3Code"
        case name
        case nativeName
        case alternativeSpellings = "altSpellings"
        case nameTranslations = "translations"
        case capital
        case languages
        case currencies
        case region
        case regionalBlocs
        case population
        case areaSize = "area"
        case center = "latlng"

    }
    
}
