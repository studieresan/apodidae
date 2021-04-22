//
//  JSONDecoder-DateDecodingStrategy+Studs.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-22.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {

	///Used to parse dates that are in ISO format with fractal seconds (which is not default when using ISO fromat in swift for some reason)
	static let iso8601WithFractalSeconds = custom { decoder in
		let container = try decoder.singleValueContainer()
		let dateString = try container.decode(String.self)

		let dateFormatter = ISO8601DateFormatter()
		dateFormatter.formatOptions = [
			.withYear,
			.withMonth,
			.withDay,
			.withTime,
			.withTimeZone,
			.withDashSeparatorInDate,
			.withColonSeparatorInTime,
			.withColonSeparatorInTimeZone,
			.withFractionalSeconds,
		]

		guard let date = dateFormatter.date(from: dateString) else {
			throw DecodingError.dataCorruptedError(
				in: container,
				debugDescription: "Could not parse iso with fractal seconds from date: \(dateString)"
			)
		}

		return date
	}
}
