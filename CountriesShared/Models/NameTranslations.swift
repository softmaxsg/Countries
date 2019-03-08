//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public struct NameTranslations: Equatable {
    
    public let translations: [String: String]
    
    public init(translations: [String: String]) {
        self.translations = translations
    }
    
}

extension NameTranslations: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        translations = try container.decode([String: String?].self)
            .filter { _, value in value != nil }
            .mapValues { $0! }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(translations)
    }
    
}
