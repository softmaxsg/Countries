//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class UserDefaultsMock: UserDefaultsProtocol {
    
    typealias GetDataImpl = (String) -> Data?
    typealias SetValueImpl = (Any?, String) -> Void

    private let getDataImpl: GetDataImpl
    private let setValueImpl: SetValueImpl

    init(getData getDataImpl: @escaping GetDataImpl,
         setValue setValueImpl: @escaping SetValueImpl) {
        self.getDataImpl = getDataImpl
        self.setValueImpl = setValueImpl
    }
    
    func data(forKey defaultName: String) -> Data? {
        return getDataImpl(defaultName)
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        setValueImpl(value, defaultName)
    }

}
