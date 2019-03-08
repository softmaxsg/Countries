//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public struct Currency: Equatable {
    
    public let code: String?
    public let name: String?
    public let symbol: String?
    
    public init(code: String?, name: String?, symbol: String?) {
        self.code = code
        self.name = name
        self.symbol = symbol
    }

}

extension Currency: Codable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case code
        case name
        case symbol
        
    }
    
}
