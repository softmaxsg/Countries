//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class CountriesViewController: UITableViewController, StateBackgroundViewSupport {
    
    private enum CellIdentifier: String {
        
        case country = "Country"
        
    }
    
    @IBOutlet weak var loadingBackgroundView: UIView?
    @IBOutlet weak var emptyBackgroundView: UIView?
    @IBOutlet weak var errorBackgroundView: ErrorView?
    
    private let assembly = CountriesAssembly()
    private lazy var viewModel = assembly.countriesViewModel(delegate: self)
    var currentState: DataState { return viewModel.currentState }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CountryViewCell.register(in: tableView, with: CellIdentifier.country.rawValue)
        
        viewModel.loadCountries()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return setStateBackgroundView(in: tableView) == nil ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentState {
        case .data(let count):
            return count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        tableView.reloadData()
    }
    
}
