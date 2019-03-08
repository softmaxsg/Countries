//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit
import CountriesShared

public final class ImageLoaderMock: ImageLoaderProtocol {
    
    public typealias LoadImageImpl = (URL, @escaping LoadingHandler, @escaping CompletionHandler) -> Cancellable
    
    private let loadImageImpl: LoadImageImpl
    
    public init(loadImage loadImageImpl: @escaping LoadImageImpl) {
        self.loadImageImpl = loadImageImpl
    }
    
    public func image(with url: URL, loadingHandler: @escaping LoadingHandler, completionHandler: @escaping CompletionHandler) -> Cancellable {
        return loadImageImpl(url, loadingHandler, completionHandler)
    }
    
}
