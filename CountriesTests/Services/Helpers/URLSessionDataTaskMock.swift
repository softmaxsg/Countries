//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
@testable import Countries

final class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    
    typealias MethodImpl = () -> Void
    
    private let resumeImpl: MethodImpl
    
    init(resume: @escaping MethodImpl) {
        self.resumeImpl = resume
    }
    
    func resume() {
        resumeImpl()
    }
    
}
