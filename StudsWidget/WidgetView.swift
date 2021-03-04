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

		let now = entry.date
		let eventDate = entry.event?.getDate() ?? Date()
		let daysUntil = Calendar.current.dateComponents([.day], from: now, to: eventDate)

		let formatter = DateFormatter()
		formatter.dateFormat = "EEEE d/M HH:mm"

		let dateString = formatter.string(from: eventDate)

		//TODO: Kolla om event är nil, returnera annat då
		return HStack {
			VStack(alignment: .leading) {
				Text("Om \(daysUntil.day!) dagar")

				Text(entry.event?.company?.name ?? "Inget företag")
					.font(.title)
					.bold()

				Text(dateString)
			}.padding()
			Spacer()
		}.background(Image.blurredBackground)
	}
}

struct WidgetView_Previews: PreviewProvider {
	static var previews: some View {
		WidgetView(entry: StudsEventEntry(date: Date(), event: sampleEvent, configuration: ConfigurationIntent()))
			.previewContext(WidgetPreviewContext(family: .systemSmall))
	}
}
