//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import Foundation

protocol CountryListViewModelDelegate: class {
    
    func stateDidChange()
    func currentCountryDidChange()
    
}

protocol CountryListViewModelProtocol {

    var currentState: DataState { get }
    func item(at index: Int) throws -> CountryListItemViewModelProtocol
    
    func loadCountries()
    func currentCountry(delegate: CurrentCountryViewModelDelegate) -> CurrentCountryViewModelProtocol?
    
}

final class CountryListViewModel: CountryListViewModelProtocol {

    private weak var delegate: CountryListViewModelDelegate?
    
    private let countriesProvider: CountriesProviderProtocol
    private let locationProvider: LocationProviderProtocol
    private let sortingService: SortingServiceProtocol
    private let filteringService: FilteringServiceProtocol

    private let operationQueue = OperationQueue()
    private var currentLocation: Result<Location>? = nil { didSet { processCountries() } }
    private var countries: [Country]? = nil { didSet { processCountries() } }
    // Helps improving performance by sorting only on changing the location or countries list
    private var sortedCountries: [Country]? = nil { didSet { updateItems() } }
    private var items: [CountryListItemViewModelProtocol] = []

    init(delegate: CountryListViewModelDelegate,
         countriesProvider: CountriesProviderProtocol,
         locationProvider: LocationProviderProtocol,
         sortingService: SortingServiceProtocol,
         filteringService: FilteringServiceProtocol) {
        self.delegate = delegate
        self.countriesProvider = countriesProvider
        self.locationProvider = locationProvider
        self.sortingService = sortingService
        self.filteringService = filteringService
    }
    
    var filteringText: String = "" { didSet { updateItems() } }
    
    private(set) var currentState = DataState.data(count: 0) { didSet { delegate?.stateDidChange() } }
    
    func item(at index: Int) throws -> CountryListItemViewModelProtocol {
        return try items.item(at: index)
    }
    
    func loadCountries() {
        currentState = .loading
        
        locationProvider.startMonitoring(delegate: self)
        
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
    
    func currentCountry(delegate: CurrentCountryViewModelDelegate) -> CurrentCountryViewModelProtocol? {
        guard let currentLocation = currentLocation, let countries = countries else { return nil }
        
        return countries
            .first { $0.countryCode2.lowercased() == currentLocation.value?.countryCode?.lowercased() }
            .map { CurrentCountryViewModel(delegate: delegate, country: $0) }
    }

}

extension CountryListViewModel: LocationProviderDelegate {
    
    func locationProvider(_ provider: LocationProviderProtocol, didUpdateLocation location: Location) {
        currentLocation = .success(location)
    }
    
    func locationProvider(_ provider: LocationProviderProtocol, didFailWithError error: Error) {
        currentLocation = .failure(error)
    }
    
}

extension CountryListViewModel {
    
    private func processCountries() {
        guard let currentLocation = currentLocation, var countries = countries else { return }

        OperationQueue.main.addOperation {
            self.delegate?.currentCountryDidChange()
        }

        // Remove current country from the list
        countries.removeAll { $0.countryCode2.lowercased() == currentLocation.value?.countryCode?.lowercased() }

        if let currentCoordinate = currentLocation.value?.coordinate {
            countries = sortingService.sorted(countries, coordinate: currentCoordinate)
        }

        sortedCountries = countries
    }
    
    private func updateItems() {
        guard let _ = currentLocation, let sortedCountries = sortedCountries else { return }
        
        let items = filteringService
            .filtered(sortedCountries, using: filteringText)
            .map(CountryListItemViewModel.init)
        
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
