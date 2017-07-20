//
//  PGServices.swift
//  PuzzleGame
//
//  Created by Abhijith on 19/07/17.
//  Copyright © 2017 Abhijith. All rights reserved.
//

import Foundation
import UIKit

class PGServices {
    
    class func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return closure(nil)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return closure(nil)
            }
            guard response != nil else {
                print("no response..!")
                return closure(nil)
            }
            guard data != nil else {
                print("no data..!")
                return closure(nil)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data!))
            }
        }; task.resume()
    }
    
}
