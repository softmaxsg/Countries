//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class CountryListViewModelDelegateMock: CountryListViewModelDelegate {
    
    typealias StateDidChangeImpl = () -> Void
    
    private let stateDidChangeImpl: StateDidChangeImpl
    
    init(stateDidChange stateDidChangeImpl: @escaping StateDidChangeImpl) {
        self.stateDidChangeImpl = stateDidChangeImpl
    }
    
    func stateDidChange() {
        stateDidChangeImpl()
    }
    
}
