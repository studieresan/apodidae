//
//  URLSession+Studs.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-21.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation

extension URLSession {
	///Similar to URLSession.shared but with more generous cache policy
	static var image: URLSession = {
		guard let session: URLSession = URLSession.shared.copy() as? URLSession else {
			return URLSession.shared
		}
		session.configuration.requestCachePolicy = .returnCacheDataElseLoad

		return session
	}()
}
