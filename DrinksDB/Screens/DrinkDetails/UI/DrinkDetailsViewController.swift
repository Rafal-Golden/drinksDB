//
//  DrinkDetailsViewController.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 22-2-2023.
//

import UIKit

class DrinkDetailsViewController: UIViewController, DrinkDetailsInterfaceIn
{
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ingradientsStackView: UIStackView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    public var presenter: DrinkDetailsInterfaceOut!

    // MARK: - init & life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.didLoad()
    }
    
    // MARK: DrinkDetailsInterfaceIn
    
    func refreshDrink(image: UIImage) {
        imageView.image = image
    }
    
    func refreshDetails(model: DrinkDetailsModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        
        for i in 0..<model.ingradients.count {
            var ingradient = model.ingradients[i]
            if i < model.measures.count && model.measures.count > 0 {
                ingradient += " - " + model.measures[i]
            }
            let ingradientLabel = UILabel(frame: .zero)
            ingradientLabel.text = ingradient
            ingradientsStackView.addArrangedSubview(ingradientLabel)
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.presenter.goBackAction()
        }))
        
        present(alert, animated: true)
    }
}
