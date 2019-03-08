//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

public typealias CountriesProviderAllCompletionHandler = (Result<[Country]>) -> Void
public typealias CountriesProviderSingleCompletionHandler = (Result<Country>) -> Void

public protocol CountriesProviderProtocol {
    
    func loadAll(completion handler: @escaping CountriesProviderAllCompletionHandler)
    func load(with code: String, completion handler: @escaping CountriesProviderSingleCompletionHandler)

}

public final class CountriesProvider: CountriesProviderProtocol {
    
    public enum Error: Swift.Error { case unknown }

    private let urlSession: URLSessionProtocol
    private let jsonDecoder: JSONDecoderProtocol
    private var urlRequest: URLRequest { return URLRequest(url: Constants.countriesUrl) }
    
    public init(urlSession: URLSessionProtocol = URLSession.shared, jsonDecoder: JSONDecoderProtocol = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    public func loadAll(completion handler: @escaping CountriesProviderAllCompletionHandler) {
        load(url: Constants.countriesUrl, completion: handler)
    }
    
    public func load(with code: String, completion handler: @escaping CountriesProviderSingleCompletionHandler) {
        load(url: Constants.countryUrl(code: code), completion: handler)
    }
    
}

extension CountriesProvider {
    
    private func load<T>(url: URL, completion handler: @escaping (Result<T>) -> Void) where T: Decodable {
        let jsonDecoder = self.jsonDecoder
        let task = urlSession.dataTask(with: URLRequest(url: url)) { (data, urlResponse, error) in
            guard let data = data, let httpResponse = urlResponse as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                handler(.failure(error ?? Error.unknown))
                return
            }
            
            do {
                let result = try jsonDecoder.decode(T.self, from: data)
                handler(.success(result))
            } catch let decodingError {
                handler(.failure(decodingError))
            }
        }
        
        task.resume()
    }
    
}
