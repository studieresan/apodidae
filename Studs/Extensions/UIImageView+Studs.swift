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
	///Optional callback called when image is fetched, called on main thread
	public func imageFromURL(url: URL, callback: ((_: UIImageView) -> Void)? = nil) {
		URLSession.image.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
				if callback != nil {
					callback!(self)
				}
            })

        }).resume()
    }

	///Get the image form a URL string. If the string is an invalid URL, nothing will happen to the image view.
	///Optional callback called when image is fetched, called on main thread
	public func imageFromURL(urlString: String, callback: ((_: UIImageView) -> Void)? = nil) {
		//If string is not a url, just return without doing anything
		guard let transformedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			  let url = URL(string: transformedURL) else {
			return
		}

		self.imageFromURL(url: url, callback: callback)
	}
}
