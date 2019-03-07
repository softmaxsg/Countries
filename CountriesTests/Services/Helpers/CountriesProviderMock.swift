//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class CountriesProviderMock: CountriesProviderProtocol {
    
    typealias LoadAllImpl = (@escaping CountriesProviderAllCompletionHandler) -> Void
    typealias LoadImpl = (String, @escaping CountriesProviderSingleCompletionHandler) -> Void

    private let loadAllImpl: LoadAllImpl
    private let loadImpl: LoadImpl

    init(loadAll loadAllImpl: @escaping LoadAllImpl, load loadImpl: @escaping LoadImpl) {
        self.loadAllImpl = loadAllImpl
        self.loadImpl = loadImpl
    }
    
    func loadAll(completion handler: @escaping CountriesProviderAllCompletionHandler) {
        loadAllImpl(handler)
    }

    func load(with code: String, completion handler: @escaping CountriesProviderSingleCompletionHandler) {
        loadImpl(code, handler)
    }
    
}
