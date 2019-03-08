//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

public final class UserDefaultsMock: UserDefaultsProtocol {
    
    public typealias GetDataImpl = (String) -> Data?
    public typealias SetValueImpl = (Any?, String) -> Void

    private let getDataImpl: GetDataImpl
    private let setValueImpl: SetValueImpl

    public init(getData getDataImpl: @escaping GetDataImpl,
                setValue setValueImpl: @escaping SetValueImpl) {
        self.getDataImpl = getDataImpl
        self.setValueImpl = setValueImpl
    }
    
    public func data(forKey defaultName: String) -> Data? {
        return getDataImpl(defaultName)
    }
    
    public func set(_ value: Any?, forKey defaultName: String) {
        setValueImpl(value, defaultName)
    }

}
