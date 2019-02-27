//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol CountryListViewModelDelegate: class {
    
    func stateDidChange()
    
}

protocol CountryListViewModelProtocol {

    var currentState: DataState { get }
    func item(at index: Int) throws -> CountryListItemViewModelProtocol
    
    func loadCountries()
    
}

final class CountryListViewModel: CountryListViewModelProtocol {

    private weak var delegate: CountryListViewModelDelegate?
    
    private let countriesProvider: CountriesProviderProtocol

    private let operationQueue = OperationQueue()
    private var countries: [Country] = [] { didSet { updateItems() } }
    private var items: [CountryListItemViewModelProtocol] = []

    init(delegate: CountryListViewModelDelegate, countriesProvider: CountriesProviderProtocol) {
        self.delegate = delegate
        self.countriesProvider = countriesProvider
    }
    
    private(set) var currentState = DataState.data(count: 0) { didSet { delegate?.stateDidChange() } }
    
    func item(at index: Int) throws -> CountryListItemViewModelProtocol {
        return try items.item(at: index)
    }
    
    func loadCountries() {
        currentState = .loading
        countriesProvider.loadAll { [weak self] result in
            self?.operationQueue.addOperation {
                switch result {
                case .success(let countries):
                    self?.countries = countries

                case .failure(let error):
                    self?.handleLoadingError(error)
                }
            }
        }
    }

}

extension CountryListViewModel {
    
    private func updateItems() {
        let items = countries.map(CountryListItemViewModel.init)
        
        OperationQueue.main.addOperation {
            self.items = items
            self.currentState = .data(count: items.count)
        }
    }
    
    private func handleLoadingError(_ error: Error) {
        OperationQueue.main.addOperation {
            self.currentState = .error(message: error.localizedDescription)
        }
    }
    
}
