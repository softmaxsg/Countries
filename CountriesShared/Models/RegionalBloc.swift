//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public struct RegionalBloc: Equatable {
    
    public let acronym: String
    public let name: String
    
    public init(acronym: String, name: String) {
        self.acronym = acronym
        self.name = name
    }
}

extension RegionalBloc: Codable {
    
    enum CodingKeys: String, CaseIterable, CodingKey {
        
        case acronym
        case name
        
    }
    
}
