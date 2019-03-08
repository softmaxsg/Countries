//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

public final class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    
    public typealias MethodImpl = () -> Void
    
    private let resumeImpl: MethodImpl
    private let cancelImpl: MethodImpl
    
    public init(resume: @escaping MethodImpl, cancel: @escaping MethodImpl) {
        self.resumeImpl = resume
        self.cancelImpl = cancel
    }
    
    public func resume() {
        resumeImpl()
    }
    
    public func cancel() {
        cancelImpl()
    }
    
}
