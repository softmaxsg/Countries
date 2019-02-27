//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class CountriesProviderMock: CountriesProviderProtocol {
    
    typealias LoadAllImpl = (@escaping CountriesProviderCompletionHandler) -> Void
    
    private let loadAllImpl: LoadAllImpl
    
    init(loadAll: @escaping LoadAllImpl) {
        self.loadAllImpl = loadAll
    }
    
    func loadAll(completion handler: @escaping CountriesProviderCompletionHandler) {
        return loadAllImpl(handler)
    }
    
}
