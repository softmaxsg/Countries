//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public struct Language: Equatable {

    public let languageCode2: String?
    public let languageCode3: String
    public let name: String
    public let nativeName: String
    
    public init(languageCode2: String?,
                languageCode3: String,
                name: String,
                nativeName: String) {
        self.languageCode2 = languageCode2
        self.languageCode3 = languageCode3
        self.name = name
        self.nativeName = nativeName
    }
    
}

extension Language: Codable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case languageCode2 = "iso639_1"
        case languageCode3 = "iso639_2"
        case name
        case nativeName
        
    }
    
}
