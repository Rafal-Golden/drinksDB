//
//  NSError+extension.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 28/02/2025.
//

import Foundation

extension NSError {
    static func appError(code: Int, description: String) -> NSError {
        return NSError(domain: "com.DrinksDB.Error", code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
