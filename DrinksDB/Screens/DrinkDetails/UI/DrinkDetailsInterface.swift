//
//  DrinkDetailsInterface.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 22-2-2023.
//

import UIKit

protocol DrinkDetailsInterfaceIn: AnyObject
{
    func refreshDetails(model: DrinkDetailsModel)
    func refreshDrink(image: UIImage)
    func showErrorAlert(message: String)
}

protocol DrinkDetailsInterfaceOut: AnyObject
{
    func didLoad()
    func goBackAction()
}
