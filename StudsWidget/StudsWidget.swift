//
//  StudsWidget.swift
//  StudsWidget
//
//  Created by Glenn Olsson on 2021-03-04.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import RxSwift

struct Provider: IntentTimelineProvider {

	var disposeBag = DisposeBag()

    func placeholder(in context: Context) -> StudsEventEntry {
		return StudsEventEntry(
			date: Date(),
			event: sampleEvent,
			configuration: ConfigurationIntent(),
			widgetFamily: context.family,
			size: context.displaySize
		)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (StudsEventEntry) -> Void) {
        let entry = StudsEventEntry(
			date: Date(),
			event: sampleEvent,
			configuration: configuration,
			widgetFamily: context.family,
			size: context.displaySize
		)
        completion(entry)
    }

	///Returns the next event, if there is one. Assumes the events are ordered like e1 < e2 < e3 etc.
	func findNextEvent(of date: Date, events: [Event]) -> Event? {
		//Filter out all events that will occur after date or same day as date (same day events should
		//always be treaded as next). As it is sorted so that earlier events are first in the list,
		//the first date will be the first event to occur after date (or on same day as date)

		let event: Event? = events
			.filter({$0.date > date || $0.date.isSameDay(as: date)})
			.first

		return event
	}

	///Returns the most recent, published event, if there is one. Assumes the events are ordered like e1 < e2 < e3 etc.
	func findLatestEvent(of date: Date, events: [Event]) -> Event? {
		//Filter out all events that are published, occured before the date (upcomming ones)
		//and did not occur on same day as event. As it is sorted so that earlier events are first in
		//the list, the last element will be the most recent event that is published and occured
		//before date
		let event: Event? = events
			.filter({$0.published && $0.date < date && !$0.date.isSameDay(as: date)})
			.last

		return event
	}

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<StudsEventEntry>) -> Void) {
		Http.fetchEvents(studsYear: nil).subscribe(onNext: { events in

			//Sorted such that the next element occured after the previous element, i.e. e1 < e2 < e3
			let sortedEvents = events.sorted(by: {$0 < $1})

			var entries: [StudsEventEntry] = []

			// Generate a timeline consisting of 4 entries 12 hours apart, starting from the current date.
			let currentDate = Date()

			let isLoggedIn = UserManager.isLoggedIn()

			for hourOffset in 0 ..< 4 {
				let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset * 12, to: currentDate)!

				//If logged in, use next event. Else use most recent published event
				let event = isLoggedIn ?
					self.findNextEvent(of: entryDate, events: sortedEvents) :
					self.findLatestEvent(of: entryDate, events: sortedEvents)

				let entry = StudsEventEntry(
					date: entryDate,
					event: event,
					configuration: configuration,
					widgetFamily: context.family,
					size: context.displaySize
				)
				entries.append(entry)
			}

			let timeline = Timeline(entries: entries, policy: .atEnd)
			completion(timeline)
		}).disposed(by: disposeBag)
    }
}

struct StudsEventEntry: TimelineEntry {
    let date: Date
	let event: Event?
    let configuration: ConfigurationIntent
	let widgetFamily: WidgetFamily
	let size: CGSize
}

@main
struct StudsWidget: Widget {
    let kind: String = "StudsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("Näst event-widget")
        .description("Visar nästa studsevent på ett snyggt sätt")
    }
}

struct StudsWidget_Previews: PreviewProvider {
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
