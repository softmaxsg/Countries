//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol CountryDetailsProtocol: CountryBriefDetailsProtocol {
    
    var capital: String { get }
    var region: String { get }
    var regionalBlocs: String { get }
    var languages: String { get }
    var currencies: String { get }
    
}
