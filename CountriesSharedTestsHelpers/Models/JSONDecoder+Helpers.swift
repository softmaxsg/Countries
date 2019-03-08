//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    public func decode<T>(_ type: T.Type, from json: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: json)
        return try decode(type, from: data)
    }
    
}
