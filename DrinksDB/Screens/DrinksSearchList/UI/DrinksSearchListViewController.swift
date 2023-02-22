//
//  DrinksSearchListViewController.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21-2-2023.
//

import UIKit

class DrinksSearchListViewController: UIViewController, DrinksSearchListInterfaceIn
{
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var failureInfoLabel: UILabel!
    @IBOutlet private weak var ingedientsLabel: UILabel!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    public var presenter: DrinksSearchListInterfaceOut!
    
    private var items: [DrinkItemCellModel] {
        return presenter.drinksModel.items
    }
    
    private var delayedFilteringBlock: DispatchWorkItem?
    private var filteringDelayInSeconds: Double = 0.6

    // eMARK: - init & life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.didLoad()
        
        failureInfoLabel.text = ""
        loadingView.stopAnimating()
    }
    
    // MARK: DrinksSearchListInterfaceIn
    
    func startLoading() {
        failureInfoLabel.alpha = 0
        loadingView.startAnimating()
    }
    
    func refreshList() {
        loadingView.stopAnimating()
        tableView.reloadData()
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func setHint(ingredients: String) {
        self.ingedientsLabel.text = ingredients
    }
    
    func showFailureInfo(message: String) {
        failureInfoLabel.text = message
        
        UIView.animate(withDuration: 0.33) {
            self.failureInfoLabel.alpha = 1.0
        }
    }
}

extension DrinksSearchListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        print(">>> \(#function) text \(textDidChange)")
        
        // I would prefer to use Combine and publiser but requirement is to support iOS11
        
        let filteringBlock = DispatchWorkItem { [weak self] in
            self?.presenter.filterBy(ingradient: textDidChange)
        }
        
        delayedFilteringBlock?.cancel()
        delayedFilteringBlock = filteringBlock
        
        DispatchQueue.main.asyncAfter(deadline: .now()+filteringDelayInSeconds, execute: filteringBlock)
    }
}

extension DrinksSearchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = DrinkItemCell.cellID
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! DrinkItemCell
        
        let item = items[indexPath.row]
        cell.configure(model: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
}

extension DrinksSearchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        self.presenter.didSelectedCell(drinkId: item.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
