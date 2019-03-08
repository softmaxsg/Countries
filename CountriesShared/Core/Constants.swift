//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public struct Constants {
    
    public static let countriesUrl = URL(string: "https://restcountries.eu/rest/v2/all")!

    public static func countryUrl(code: String) -> URL {
        return URL(string: String(format: "https://restcountries.eu/rest/v2/alpha/%@", code.lowercased()))!
    }
    
    public static func countryFlagUrl(code: String) -> URL {
        return URL(string: String(format: "https://flagpedia.net/data/flags/small/%@.png", code.lowercased()))!
    }
    
    public static let sharedStorageName = "group.CountriesSharedStorage"
    
}
