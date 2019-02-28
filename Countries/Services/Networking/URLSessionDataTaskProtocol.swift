//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    
    func resume()
    
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
