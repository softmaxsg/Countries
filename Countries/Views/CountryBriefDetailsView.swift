//
//  Copyright © 2019 Vitaly Chupryk. All rights reserved.
//

import UIKit

final class CountryBriefDetailsView: UIView, ImageContainerView {
    
    private lazy var placeholderImage = UIImage(named: "FlagPlaceholder")!
    
    @IBOutlet weak var countryFlagImage: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var populationLabel: UILabel?
    @IBOutlet weak var areaSizeLabel: UILabel?
    @IBOutlet weak var areaSizeWrapper: UIView?
    
    var imageLoader: ImageLoaderProtocol = DependencyContainer.shared.imageLoader
    var currentImageLoaderTask: Cancellable?
    
    // ImageContainerView works with `imageView` property
    var imageView: UIImageView? { return countryFlagImage }
    
    func configure(with details: CountryBriefDetailsViewModelProtocol) {
        nameLabel?.text = details.name
        populationLabel?.text = details.population
        areaSizeLabel?.text = details.areaSize
        areaSizeWrapper?.isHidden = details.areaSize.isEmpty
        
        displayImage(with: details.flagUrl, placeholder: placeholderImage)
    }
    
}
