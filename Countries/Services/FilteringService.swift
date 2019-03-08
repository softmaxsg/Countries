//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

protocol FilteringServiceProtocol {
    
    func filtered(_ countries: [Country], using text: String) -> [Country]
    
}

final class FilteringService: FilteringServiceProtocol {
    
    func filtered(_ countries: [Country], using text: String) -> [Country] {
        guard !text.isEmpty else { return countries }
        return countries.filter { country in
            if contains(text, in: country.countryCode2) { return true }
            if contains(text, in: country.countryCode3) { return true }
            if contains(text, in: country.name) { return true }
            if contains(text, in: country.nativeName) { return true }
            if contains(text, in: country.capital) { return true }
            if contains(text, in: country.alternativeSpellings) { return true }

            let nameTranslations = country.nameTranslations.translations.map { _, value in value }
            if contains(text, in: nameTranslations) { return true }

            let languages = country.languages.flatMap { language in
                ([
                    language.languageCode2,
                    language.languageCode3,
                    language.name,
                    language.nativeName
                ] as [String?]).compactMap { $0 }
            }
            if contains(text, in: languages) { return true }

            return false
        }
    }
    
}

extension FilteringService {
    
    private func contains(_ text: String, in string: String) -> Bool {
        let range = (string as NSString).range(of: text, options: [.caseInsensitive, .widthInsensitive, .diacriticInsensitive])
        return range.length > 0
    }
    
    private func contains(_ text: String, in strings: [String]) -> Bool {
        return strings.contains { contains(text, in: $0) }
    }

}
