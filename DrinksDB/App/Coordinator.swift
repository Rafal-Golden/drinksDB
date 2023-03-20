//
//  Coordinator.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 02/03/2023.
//

import Foundation

protocol Coordinator: AnyObject
{
    func start()
    
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void)
}

extension Coordinator
{
    func navigate(to destination: Destination)
    {
        navigate(to: destination, animated: true) { }
    }
}
