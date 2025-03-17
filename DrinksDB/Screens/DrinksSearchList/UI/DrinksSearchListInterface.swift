//
//  DrinksSearchListInterface.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21-2-2023.
//

import UIKit

protocol DrinksSearchListInterfaceIn: AnyObject
{
    func startLoading()
    func refreshList()
    func showFailureInfo(message: String)
    func setTitle(_ title: String)
    func setHint(ingredients: String)
    func setRandomButton(title: String?)
    func setSearchTypeUI(_ viewModel: SearchViewModel)
}

protocol DrinksSearchListInterfaceOut: AnyObject
{
    var drinksModel: DrinksModel { get }
    
    func didLoad()
    func didSelectedCell(drinkId: String)
    func searchBy(phrase: String)
    func didSelectedSearchTypeBy(ingredient: Bool, phrase: String)
}
