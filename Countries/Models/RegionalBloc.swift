//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

struct RegionalBloc: Equatable {
    
    let acronym: String
    let name: String
    
}

extension RegionalBloc: Codable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case acronym
        case name
        
    }
    
}
