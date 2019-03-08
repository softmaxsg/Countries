//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation
import CountriesShared

public final class URLSessionMock: URLSessionProtocol {
    
    public typealias DataTaskImpl = (URLRequest, @escaping DataTaskHandler) -> URLSessionDataTaskProtocol
    
    private let dataTaskImpl: DataTaskImpl
    
    public init(dataTask: @escaping DataTaskImpl) {
        self.dataTaskImpl = dataTask
    }
    
    public func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        return dataTaskImpl(request, completionHandler)
    }
    
}
