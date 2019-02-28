//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol Cancellable {
    
    func cancel()
    
}

class EmptyTask: Cancellable {
    
    func cancel() { }
    
}
