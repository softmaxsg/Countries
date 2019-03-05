//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct Currency: Equatable {
    
    let code: String?
    let name: String?
    let symbol: String?

}

extension Currency: Codable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case code
        case name
        case symbol
        
    }
    
}
