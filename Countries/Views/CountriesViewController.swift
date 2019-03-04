//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class CountriesViewController: UIViewController, TableViewContainer, StateBackgroundViewSupport {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingBackgroundView: UIView?
    @IBOutlet weak var emptyBackgroundView: UIView?
    @IBOutlet weak var errorBackgroundView: ErrorView?
    
    @IBOutlet weak var currentCountryView: UIView?

    private let assembly = CountriesAssembly()
    private lazy var viewModel = assembly.countriesViewModel(delegate: self)
    var currentState: DataState { return viewModel.currentState }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CountryViewCell.register(in: tableView, with: CellIdentifier.country.rawValue)
        
        currentCountryView?.isHidden = true
        
        updateControls()
        viewModel.loadCountries()
    }
    
}

extension CountriesViewController: UITableViewDataSource {
    
    private enum CellIdentifier: String {
        
        case country = "Country"
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return setStateBackgroundView(in: tableView) == nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentState {
        case .data(let count):
            return count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.country.rawValue, for: indexPath)
        if let cell = cell as? CountryViewCell, let item = try? viewModel.item(at: indexPath.row) {
            cell.configure(with: item)
        } else {
            assertionFailure()
        }
        
        return cell
    }

}

extension CountriesViewController: CountryListViewModelDelegate {
    
    func stateDidChange() {
        updateControls()
        tableView.reloadData()
    }
    
}

extension CountriesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filteringText = searchController.searchBar.text ?? ""
    }
    
}

extension CountriesViewController {
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Filter countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.text = viewModel.filteringText
        
        // Allows to show search bar immediately but still let it hide when scrolling
        navigationItem.hidesSearchBarWhenScrolling = false
        defer { navigationItem.hidesSearchBarWhenScrolling = true }
    }
    
    private func updateControls() {
        switch currentState {
        case .data:
            if navigationItem.searchController == nil {
                configureSearchController()
            }
            
        default:
            navigationItem.searchController = nil
        }
    }
    
}
