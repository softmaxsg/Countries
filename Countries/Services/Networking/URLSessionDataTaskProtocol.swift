//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol: Cancellable {
    
    func resume()
    
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
