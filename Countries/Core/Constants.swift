//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct Constants {
    
    static let countriesUrl = URL(string: "https://restcountries.eu/rest/v2/all")!

    static func countryUrl(code: String) -> URL {
        return URL(string: String(format: "https://restcountries.eu/rest/v2/alpha/%@", code.lowercased()))!
    }
    
    static func countryFlagUrl(code: String) -> URL {
        return URL(string: String(format: "https://flagpedia.net/data/flags/small/%@.png", code.lowercased()))!
    }
    
    static let sharedStorageName = "group.CountriesSharedStorage"
    
}
