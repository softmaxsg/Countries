//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol JSONEncoderProtocol {
    
    func encode<T>(_ value: T) throws -> Data where T : Encodable
    
}

extension JSONEncoder: JSONEncoderProtocol { }
