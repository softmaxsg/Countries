//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import XCTest
@testable import Countries

extension XCTestCase {
    
    func mockedSession(expectedUrl: URL, resultStatusCode: Int, result: Result<Data>, expectation: XCTestExpectation? = nil, file: StaticString = #file, line: UInt = #line) -> URLSessionProtocol {
        return URLSessionMock { request, completion in
            XCTAssertEqual(request.url, expectedUrl, file: file, line: line)
            
            return URLSessionDataTaskMock {
                let urlResponse = HTTPURLResponse(
                    url: request.url!,
                    statusCode: resultStatusCode,
                    httpVersion: nil,
                    headerFields: nil
                )
                
                OperationQueue.main.addOperation {
                    completion(result.value, urlResponse, result.error)
                    expectation?.fulfill()
                }
            }
        }
    }
    
}
