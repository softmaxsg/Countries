//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public enum JSONEncoderError: Error { case unknown }

extension JSONEncoder {
    
    public func encodeToJSON<T>(_ value: T) throws -> [String: Any] where T : Encodable {
        let data = try encode(value)
        guard let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw JSONEncoderError.unknown
        }
        
        return jsonObject
    }
    
}
