//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public enum Result<Value> {

    case success(Value)
    case failure(Error)
    
}

extension Result {

    public init(value: Value) {
        self = .success(value)
    }
    
    public init(error: Error) {
        self = .failure(error)
    }
    
    public var value: Value? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
    
    public func map<T>(_ transform: (Value) throws -> T) rethrows -> Result<T> {
        switch self {
        case .success(let value): return .success(try transform(value))
        case .failure(let error): return .failure(error)
        }
    }
    
}
