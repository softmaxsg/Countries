//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class CountryListViewModelDelegateMock: CountryListViewModelDelegate {
    
    typealias MethodImpl = () -> Void
    
    private let stateDidChangeImpl: MethodImpl
    private let currentCountryDidChangeImpl: MethodImpl

    init(stateDidChange stateDidChangeImpl: @escaping MethodImpl,
         currentCountryDidChange currentCountryDidChangeImpl: @escaping MethodImpl) {
        self.stateDidChangeImpl = stateDidChangeImpl
        self.currentCountryDidChangeImpl = currentCountryDidChangeImpl
    }
    
    func stateDidChange() {
        stateDidChangeImpl()
    }
    
    func currentCountryDidChange() {
        currentCountryDidChangeImpl()
    }

}
