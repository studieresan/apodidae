//
//  WidgetView.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-04.
//  Copyright © 2021 Studieresan. All rights reserved.
//
import WidgetKit
import Foundation
import SwiftUI

struct WidgetView: View {
	var entry: Provider.Entry

	var body: some View {

		var description1: String!
		var titleDescription: String!
		var description2: String!
		var widgetURL: URL? //Deeplink

		//If there is indeed an event
		if let event = entry.event {
			let now = entry.date
			let eventDate = event.getDate()

			let formatter = DateFormatter()
			formatter.dateFormat = "EEEE d/M HH:mm"

			let dateString = formatter.string(from: eventDate)

			if now.isSameDay(as: eventDate) {
				description1 = "Idag!"
			} else {
			let untilDate = Calendar.current.dateComponents([.day], from: now, to: eventDate)
				var daysUntil: Int = untilDate.day ?? -1 //will be seen as -1 but good because of debugging
				// If 0 days but not same day means that we are on the day before
				if daysUntil == 0 && !now.isSameDay(as: event.getDate()) {
					daysUntil = 1
				}

				//Special case if we are on the day before
				if daysUntil == 1 {
					description1 = "Imorgon!"
				} else {
					description1 = "Om \(daysUntil) dagar"
				}
			}
			titleDescription = event.company?.name ?? "Inget företagsnamn"
			description2 = dateString

			let widgetURLString = "studs-widget://event?id=\(event.id)"
			widgetURL = URL(string: widgetURLString)
		} else {
			description1 = "Snart..."
			titleDescription = "Studs"
			description2 = "Inget event planerat"
			widgetURL = nil
		}

		let widgetWidth = entry.size.width
		let logoSize = 0.2 * widgetWidth

		return
			//Show logo on top of other stack
			ZStack {
				HStack {
					VStack(alignment: .leading) {
						Text(description1)

						Text(titleDescription)
							.font(.title)
							.bold()
							.minimumScaleFactor(0.01) // Allow font scaling of title if to big
							.lineLimit(1)

						if entry.widgetFamily != .systemSmall {
							Text("\(description2)")
						}
					}
					.fixedSize(horizontal: false, vertical: true)
					.padding()

					Spacer()
				}
				VStack(alignment: .trailing) {
					HStack {
						Spacer()
						Image.studsS
							.resizable()
							.frame(width: logoSize, height: logoSize, alignment: .topTrailing)
					}
					.padding()
					Spacer()
				}
			}
			.background(Image.blurredBackground)
			.widgetURL(widgetURL)
	}
}

struct WidgetView_Previews: PreviewProvider {
	static var previews: some View {
		let family: WidgetFamily = .systemSmall

		let sizeSmall = CGSize(width: 158, height: 158)
		let sizeMedium = CGSize(width: 338, height: 150)
		let sizeLarge = CGSize(width: 338, height: 354)

		var size: CGSize!
		switch family {
		case .systemSmall:
			size = sizeSmall
		case .systemMedium:
			size = sizeMedium
		case .systemLarge:
			size = sizeLarge
		@unknown default:
			fatalError()
		}

		return WidgetView(
			entry: StudsEventEntry(
				date: Date(),
				event: sampleEvent,
				configuration: ConfigurationIntent(),
				widgetFamily: family,
				size: size
			)
		)
		.previewContext(WidgetPreviewContext(family: family))
	}
}
