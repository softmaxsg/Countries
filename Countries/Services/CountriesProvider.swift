//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

typealias CountriesProviderCompletionHandler = (Result<[Country]>) -> Void

protocol CountriesProviderProtocol {
    
    func loadAll(completion handler: @escaping CountriesProviderCompletionHandler)

}

final class CountriesProvider: CountriesProviderProtocol {
    
    enum Error: Swift.Error { case unknown }

    private let urlSession: URLSessionProtocol
    private let jsonDecoder: JSONDecoderProtocol
    private var urlRequest: URLRequest { return URLRequest(url: Constants.countriesUrl) }
    
    init(urlSession: URLSessionProtocol = URLSession.shared, jsonDecoder: JSONDecoderProtocol = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    func loadAll(completion handler: @escaping CountriesProviderCompletionHandler) {
        let jsonDecoder = self.jsonDecoder
        let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let data = data, let httpResponse = urlResponse as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                handler(.failure(error ?? Error.unknown))
                return
            }
            
            do {
                let countries = try jsonDecoder.decode([Country].self, from: data)
                handler(.success(countries))
            } catch let decodingError {
                handler(.failure(decodingError))
            }
        }
        
        task.resume()
    }
}
