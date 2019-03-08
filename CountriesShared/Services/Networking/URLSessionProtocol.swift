//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    
    typealias DataTaskHandler = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {

    // Required just to allow using URLSessionDataTaskProtocol as a return type
    public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
    
}
