//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct NameTranslations: Equatable {
    
    let translations: [String: String]
    
}

extension NameTranslations: Codable {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        translations = try container.decode([String: String?].self)
            .filter { _, value in value != nil }
            .mapValues { $0! }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(translations)
    }
    
}
