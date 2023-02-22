//
//  DrinkImageDownloader.swift
//  DrinksDB
//
//  Created by Rafal Korzynski on 21/02/2023.
//

import UIKit

class DrinkImageDownloader {
    
    let imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    func download(completed: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageUrl) else {
            completed(nil)
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { imgData, _, error in
            DispatchQueue.main.async {
                if let imgData, error == nil {
                    completed(UIImage(data: imgData))
                } else {
                    completed(nil)
                }
            }
        }
        task.resume()
    }
}
