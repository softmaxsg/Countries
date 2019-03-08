//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

public final class CountriesProviderMock: CountriesProviderProtocol {
    
    public typealias LoadAllImpl = (@escaping CountriesProviderAllCompletionHandler) -> Void
    public typealias LoadImpl = (String, @escaping CountriesProviderSingleCompletionHandler) -> Void

    private let loadAllImpl: LoadAllImpl
    private let loadImpl: LoadImpl

    public init(loadAll loadAllImpl: @escaping LoadAllImpl, load loadImpl: @escaping LoadImpl) {
        self.loadAllImpl = loadAllImpl
        self.loadImpl = loadImpl
    }
    
    public func loadAll(completion handler: @escaping CountriesProviderAllCompletionHandler) {
        loadAllImpl(handler)
    }

    public func load(with code: String, completion handler: @escaping CountriesProviderSingleCompletionHandler) {
        loadImpl(code, handler)
    }
    
}

extension CountriesProviderMock {
    
    public static var empty: CountriesProviderMock {
        return CountriesProviderMock(loadAll: { _ in }, load: { _, _ in })
    }
    
}
