//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

extension Country {
    
    static func random(countryCode2: String = .random(),
                       countryCode3: String = .random(),
                       name: String = .random(),
                       nativeName: String = .random(),
                       alternativeSpellings: [String] = .random(maxCount: 5) { .random() },
                       nameTranslations: NameTranslations = .random(),
                       capital: String = .random(),
                       languages: [Language] = .random(maxCount: 5) { .random() },
                       population: UInt64 = .random(in: 1..<10_000_000_000),
                       areaSize: Double? = .random(in: 1..<100_000_000),
                       center: Coordinate = .random()) -> Country {
        return Country(
            countryCode2: countryCode2,
            countryCode3: countryCode3,
            name: name,
            nativeName: nativeName,
            alternativeSpellings: alternativeSpellings,
            nameTranslations: nameTranslations,
            capital: capital,
            languages: languages,
            population: population,
            areaSize: areaSize,
            center: center
        )
    }
    
}

extension Country: JSONPresentable {
    
    func JSON() -> [String: Any] {
        return [
            "alpha2Code": countryCode2,
            "alpha3Code": countryCode3,
            "name": name,
            "nativeName": nativeName,
            "altSpellings": alternativeSpellings,
            "translations": nameTranslations.JSON(),
            "capital": capital,
            "languages": languages.map { $0.JSON() },
            "population": population,
            "area": areaSize as Any,
            "latlng": [center.latitude, center.longitude],
        ]
    }
    
}
