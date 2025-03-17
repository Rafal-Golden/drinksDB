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
    @IBOutlet private weak var randomDrinkButton: UIButton!
    @IBOutlet private weak var searchTypeButton: UIButton!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    public var presenter: DrinksSearchListInterfaceOut!
    
    private var items: [DrinkItemCellModel] {
        return presenter.drinksModel.items
    }
    
    private var delayedSearchBlock: DispatchWorkItem?
    private var searchingDelayInSeconds: Double = 0.6
    private var randomDrinkTitle: String?

    // eMARK: - init & life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.didLoad()
        
        failureInfoLabel.text = ""
        loadingView.stopAnimating()
    }
    
    @IBAction func randomDrinkAction(_ sender: UIButton) {
        if let randomDrinkTitle {
            searchBar.text = randomDrinkTitle
            searchBar(searchBar, textDidChange: randomDrinkTitle)
        }
    }
    
    @IBAction func searchTypeAction(_ sender: UIButton) {
        searchTypeButton.isSelected.toggle()
        presenter.didSelectedSearchTypeBy(ingredient: searchTypeButton.isSelected, phrase: searchBar.text ?? "")
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
    
    func setRandomButton(title: String?) {
        var isHidden = false
        
        guard let title else {
            isHidden = true
            randomDrinkButton.setTitle("", for: .normal)
            return
        }
        
        let randomTitle = "Random: \(title)"
        
        randomDrinkButton.titleLabel?.numberOfLines = 2
        randomDrinkButton.setTitle(randomTitle, for: .normal)
        randomDrinkButton.isHidden = isHidden
        randomDrinkTitle = title
    }
    
    func setSearchTypeUI(_ viewModel: SearchViewModel) {
        searchTypeButton.setTitle(viewModel.searchTitle, for: .normal)
        searchTypeButton.setTitle(viewModel.ingredientTitle, for: .selected)
        searchTypeButton.isSelected = viewModel.ingredientType
        searchBar.placeholder = viewModel.placeholder
    }
}

extension DrinksSearchListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {        
        // I would prefer to use Combine and publisher but requirement is to support iOS11
                
        let searchingBlock = DispatchWorkItem { [weak self] in
            self?.presenter.searchBy(phrase: textDidChange)
        }
        
        delayedSearchBlock?.cancel()
        delayedSearchBlock = searchingBlock
        
        DispatchQueue.main.asyncAfter(deadline: .now()+searchingDelayInSeconds, execute: searchingBlock)
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
