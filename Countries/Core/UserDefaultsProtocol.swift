//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
    
    func data(forKey defaultName: String) -> Data?
    func set(_ value: Any?, forKey defaultName: String)
    
}

extension UserDefaults: UserDefaultsProtocol { }
