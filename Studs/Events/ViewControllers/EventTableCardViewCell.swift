//
//  EventTableCardViewCell.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-02.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import SwiftUI

@available(iOS 14, *)
struct EventTableCardViewCell: View {

	let event: Event

	var body: some View {

		let date = event.getDate()

		let formatter = DateFormatter()
		formatter.dateFormat = "d MMMM"

		let dayDate = formatter.string(from: date)

		formatter.dateFormat = "HH:mm"

		let timeDate = formatter.string(from: date)

		return HStack {
			VStack(alignment: .leading) {
				Text(event.company?.name ?? "Company")
					.font(.title2)
				Text(dayDate)

				VStack(alignment: .leading) {
					EventCardIconRow(text: timeDate, iconName: "clock")
					EventCardIconRow(text: event.location ?? "Okänt", iconName: "mappin.circle")
				}
				.padding(.top)

				Spacer()
			}
			.padding()

			Spacer()

			VStack {
				Spacer()

				Text("Läs mer >")
					.padding()
			}
		}
		.background(
			Image.blurredBackground
				.resizable()
				.scaledToFill())
	}
}

@available(iOS 14, *)
struct EventCardIconRow: View {

	let text: String
	let iconName: String

	var body: some View {
		HStack {
			Image(systemName: iconName)
				.padding(.trailing)

			Text(text)
		}
	}
}

@available(iOS 14, *)
struct EventTableCardViewCellPreview: PreviewProvider {

	static var previews: some View {
		let maxWidth = UIApplication.shared.keyWindow!.frame.width
		let height: CGFloat = 200

		return HStack {
			EventTableCardViewCell(event: sampleEvent)
				.border(Color.red)
		}
		.frame(width: maxWidth, height: height, alignment: .center)
	}
}
