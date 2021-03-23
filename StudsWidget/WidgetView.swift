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
			let eventDate = entry.event?.getDate() ?? Date()
			let daysUntil = Calendar.current.dateComponents([.day], from: now, to: eventDate)

			let formatter = DateFormatter()
			formatter.dateFormat = "EEEE d/M HH:mm"

			let dateString = formatter.string(from: eventDate)

			description1 = "Om \(daysUntil.day!) dagar"
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
		let family: WidgetFamily = .systemMedium

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
