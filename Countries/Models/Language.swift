//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct Language: Equatable {

    let languageCode2: String?
    let languageCode3: String
    let name: String
    let nativeName: String
    
}

extension Language: Decodable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case languageCode2 = "iso639_1"
        case languageCode3 = "iso639_2"
        case name
        case nativeName
        
    }
    
}
