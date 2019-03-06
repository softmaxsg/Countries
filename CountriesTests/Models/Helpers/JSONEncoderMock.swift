//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class JSONEncoderMock<T: Encodable>: JSONEncoderProtocol {
    
    typealias EncodeImpl = (T) throws -> Data
    
    private let encodeImpl: EncodeImpl
    
    init(encodeImpl: @escaping EncodeImpl) {
        self.encodeImpl = encodeImpl
    }
    
    func encode<U>(_ value: U) throws -> Data where U: Encodable {
        assert(T.self == U.self)
        return try encodeImpl(value as! T)
    }
    
}
