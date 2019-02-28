//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct Country: Equatable {
    
    let countryCode2: String
    let name: String
    let nativeName: String
    let population: UInt64
    let areaSize: Double?
    
}

extension Country: Decodable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case countryCode2 = "alpha2Code"
        case name
        case nativeName
        case population
        case areaSize = "area"

    }
    
}
