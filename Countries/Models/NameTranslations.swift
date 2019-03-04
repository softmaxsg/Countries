//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct NameTranslations: Equatable {
    
    let translations: [String: String]
    
}

extension NameTranslations: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        translations = try container.decode([String: String?].self)
            .filter { _, value in value != nil }
            .mapValues { $0! }
    }
    
}
