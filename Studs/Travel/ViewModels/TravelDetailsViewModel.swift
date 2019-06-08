//
//  TravelDetailsViewModel.swift
//  Studs
//
//  Created by Willy Liu on 2019-06-08.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class TravelDetailsViewModel {

    weak var delegate: TravelDetailsViewModelDelegate?

    private let dbRef = Database.database()
    private var feedItems: [FeedItem] = [] {
        didSet {
            delegate?.onNewValues()
        }
    }

    func setupDbListener() {
        dbRef.reference(withPath: "locations").queryOrdered(byChild: "timestamp").observe(.value) { (snapshot) in
            var items: [FeedItem] = []
            for child in snapshot.children {
                guard
                    let child = child as? DataSnapshot,
                    let dict = child.value as? [String: Any]
                    else {
                        return
                }
                let feedItem = FeedItem(withDict: dict)
                items += [feedItem]
            }
            self.feedItems = items.reversed()
        }
    }

    func removeDbListeners() {
        dbRef.reference(withPath: "locations").removeAllObservers()
    }

    func getFeedItem(forIndexPath indexPath: IndexPath) -> FeedItem {
        return self.feedItems[indexPath.row]
    }

    func numberOfFeedItems() -> Int {
        return self.feedItems.count
    }
}

protocol TravelDetailsViewModelDelegate: class {

    func onNewValues()

}
