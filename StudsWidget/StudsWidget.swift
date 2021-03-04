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
		StudsEventEntry(date: Date(), event: sampleEvent, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (StudsEventEntry) -> Void) {
        let entry = StudsEventEntry(date: Date(), event: sampleEvent, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
		let studsYear = Bundle.main.infoDictionary?["STUDS_YEAR"] as? Int
		Http.fetchEvents(studsYear: studsYear).subscribe(onNext: { events in

			//Sorted in reverse
			let sortedEvents = events.sorted(by: {$0 > $1})

			var entries: [StudsEventEntry] = []

			// Generate a timeline consisting of five entries a day apart, starting from the current date.
			let currentDate = Date()

			var nextEvent: Event? = sortedEvents.first
			for hourOffset in 0 ..< 5 {
				let entryDate = Calendar.current.date(byAdding: .day, value: hourOffset, to: currentDate)!

				//Don't search if was nil last time, means that this will also be nil
				if nextEvent != nil {
					//Find index offirst event where entryDate is before eventDate, i.e. the event
					//before in list is the next event
					let firstEventAfterDate = sortedEvents.firstIndex(where: {event in
						return event.getDate() < entryDate
					})
					//If index exists and is bigger than 0 (i.e. there exists a next event)
					if let index = firstEventAfterDate, index >= 1 {
						nextEvent = sortedEvents[index - 1]
					} else {
						nextEvent = nil
					}
				}

				let entry = StudsEventEntry(date: entryDate, event: nextEvent, configuration: configuration)
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
}

struct StudsWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {

        return Text(entry.date, style: .time)
    }
}

@main
struct StudsWidget: Widget {
    let kind: String = "StudsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            StudsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct StudsWidget_Previews: PreviewProvider {
    static var previews: some View {
		StudsWidgetEntryView(entry: StudsEventEntry(date: Date(), event: sampleEvent, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
