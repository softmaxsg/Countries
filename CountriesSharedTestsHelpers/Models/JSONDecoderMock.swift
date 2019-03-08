//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

public final class JSONDecoderMock<T: Decodable>: JSONDecoderProtocol {
    
    public typealias DecodeImpl = (Data) throws -> T
    
    private let decodeImpl: DecodeImpl
    
    public init(decodeImpl: @escaping DecodeImpl) {
        self.decodeImpl = decodeImpl
    }
    
    public func decode<U>(_ type: U.Type, from data: Data) throws -> U where U: Decodable {
        assert(T.self == U.self)
        return try decodeImpl(data) as! U
    }
    
}
