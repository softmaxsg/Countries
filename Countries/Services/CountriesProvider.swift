//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

typealias CountriesProviderAllCompletionHandler = (Result<[Country]>) -> Void
typealias CountriesProviderSingleCompletionHandler = (Result<Country>) -> Void

protocol CountriesProviderProtocol {
    
    func loadAll(completion handler: @escaping CountriesProviderAllCompletionHandler)
    func load(with code: String, completion handler: @escaping CountriesProviderSingleCompletionHandler)

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
    
    func loadAll(completion handler: @escaping CountriesProviderAllCompletionHandler) {
        load(url: Constants.countriesUrl, completion: handler)
    }
    
    func load(with code: String, completion handler: @escaping CountriesProviderSingleCompletionHandler) {
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
