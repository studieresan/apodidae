//
//  TravelViewModel.swift
//  Studs
//
//  Created by Willy Liu on 2019-06-11.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import Foundation

final class TravelViewModel {

    weak var delegate: TravelViewModelDelegate?
//    private let dbRef = Database.database()
    private let ownUsername = UserManager.getUserData()?.name

    func setupLiveLocationListener() {
//        dbRef.reference(withPath: "live-locations").observe(.value) { snapshot in
//            for child in snapshot.children {
//                guard
//                    let child = child as? DataSnapshot,
//                    let dict = child.value as? [String: Any]
//                    else {
//                        return
//                }
//                let location = LastKnownLocation(fromDict: dict)
//
//                // We don't want to show our own live location on the map
//                if location.user != self.ownUsername {
//                    self.delegate?.onNewLiveLocation(latestLocation: location)
//                }
//            }
//        }
    }

    func removeLiveLocationListener() {
//        dbRef.reference(withPath: "live-locations").removeAllObservers()
    }

    func updateOwnLiveLocation(currentLocation loc: LastKnownLocation) {
//        dbRef.reference(withPath: "live-locations").child(loc.user).setValue(loc.asDict())
    }

}

protocol TravelViewModelDelegate: class {

    func onNewLiveLocation(latestLocation: LastKnownLocation)

}
