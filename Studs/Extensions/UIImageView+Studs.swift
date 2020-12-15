//
//  UIImageView+Studs.swift
//  Studs
//
//  Created by Willy Liu on 2019-06-09.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

extension UIImageView {

    // https://stackoverflow.com/questions/39813497/swift-3-display-image-from-url/46788201
    public func imageFromURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, _, error) -> Void in

            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
}
