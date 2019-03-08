//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public protocol URLSessionDataTaskProtocol: Cancellable {
    
    func resume()
    
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
