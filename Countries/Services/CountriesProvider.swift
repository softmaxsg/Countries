//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

typealias CountriesProviderCompletionHandler = (Result<[Country]>) -> Void

protocol CountriesProviderProtocol {
    
    func loadAll(completion handler: @escaping CountriesProviderCompletionHandler)

}
