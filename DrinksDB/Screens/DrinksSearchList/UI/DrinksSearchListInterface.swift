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
}

protocol DrinksSearchListInterfaceOut: AnyObject
{
    var drinksModel: DrinksModel { get }
    
    func didLoad()
    func didSelectedCell(drinkId: String)
    func filterBy(ingradient: String)
}
