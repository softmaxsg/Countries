//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

public final class JSONEncoderMock<T: Encodable>: JSONEncoderProtocol {
    
    public typealias EncodeImpl = (T) throws -> Data
    
    private let encodeImpl: EncodeImpl
    
    public init(encodeImpl: @escaping EncodeImpl) {
        self.encodeImpl = encodeImpl
    }
    
    public func encode<U>(_ value: U) throws -> Data where U: Encodable {
        assert(T.self == U.self)
        return try encodeImpl(value as! T)
    }
    
}
