//
//  DrinkItemCell.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21/02/2023.
//

import UIKit

class DrinkItemCell: UITableViewCell {
    
    static let cellID = "DrinkItemCellID"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imgView: UIImageView!
    
    private var imageDownloader: DrinkImageDownloader?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imgView.image = nil
    }
    
    func configure(model: DrinkItemCellModel) {
        titleLabel.text = model.title
        
        imageDownloader = DrinkImageDownloader(imageUrl: model.imageUrl)
        imageDownloader?.download(completed: { [weak self] image in
            self?.imgView.image = image
        })
    }
}
