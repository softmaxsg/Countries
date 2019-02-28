//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class CountryViewCell: UITableViewCell, ImageContainerView {
    
    private lazy var placeholderImage = UIImage(named: "FlagPlaceholder")!

    @IBOutlet weak var countryFlagImage: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var populationLabel: UILabel?
    @IBOutlet weak var areaSizeLabel: UILabel?
    @IBOutlet weak var areaSizeWrapper: UIView?

    var imageLoader: ImageLoaderProtocol = DependencyContainer.shared.imageLoader
    var currentImageLoaderTask: Cancellable?
    
    // ImageContainerView works with `imageView` property
    override var imageView: UIImageView? { return countryFlagImage }

    func configure(with viewModel: CountryListItemViewModelProtocol) {
        nameLabel?.text = viewModel.name
        populationLabel?.text = viewModel.population
        areaSizeLabel?.text = viewModel.areaSize
        areaSizeWrapper?.isHidden = viewModel.areaSize.isEmpty
        
        displayImage(with: viewModel.flagUrl, placeholder: placeholderImage)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cancelImageLoading()
    }
    
}

extension CountryViewCell {
    
    class func register(in tableView: UITableView, with identifier: String) {
        tableView.register(
            UINib(nibName: "CountryViewCell", bundle: nil),
            forCellReuseIdentifier: identifier
        )
    }
    
}

