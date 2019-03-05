//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class CurrentCountryViewModelDelegateMock: CurrentCountryViewModelDelegate {
    
    typealias MethodImpl = () -> Void
    
    private let viewModeDidChangeImpl: MethodImpl
    
    init(viewModeDidChange viewModeDidChangeImpl: @escaping MethodImpl) {
        self.viewModeDidChangeImpl = viewModeDidChangeImpl
    }
    
    func viewModeDidChange() {
        viewModeDidChangeImpl()
    }
    
}

extension CurrentCountryViewModelDelegateMock {
    
    static var empty: CurrentCountryViewModelDelegateMock {
        return CurrentCountryViewModelDelegateMock { }
    }
    
}
