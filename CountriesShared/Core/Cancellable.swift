//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public protocol Cancellable {
    
    func cancel()
    
}

public class EmptyTask: Cancellable {
    
    public init() { }
    
    public func cancel() { }
    
}
