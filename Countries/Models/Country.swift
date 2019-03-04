//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct Country: Equatable {
    
    let countryCode2: String
    let countryCode3: String
    let name: String
    let nativeName: String
    let alternativeSpellings: [String]
    let nameTranslations: NameTranslations
    let capital: String
    let languages: [Language]
    let population: UInt64
    let areaSize: Double?
    let center: Coordinate
    
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
        case population
        case areaSize = "area"
        case center = "latlng"

    }
    
}
