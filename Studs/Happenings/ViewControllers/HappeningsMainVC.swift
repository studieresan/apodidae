//
//  HappeningsMainVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

//TODO: Cache mapview and listview as to not have to rerender them at every switch
class HappeningsMainVC: UIViewController {

	//Each segment title
	let segments: [String] = [
		"Kartvy",
		"Listvy",
	]

	@IBOutlet weak var subviewTypeSwitch: UISegmentedControl!
	@IBOutlet weak var happeningsSubview: UIView!

	var currentSubviewIndex = 0

	@IBAction func didPressNewHappening(_ sender: Any) {
		print("new happening")
	}

	@IBAction func didSwitchSubviewType(_ sender: Any) {
		self.currentSubviewIndex = self.subviewTypeSwitch.selectedSegmentIndex
		self.reloadSubview()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.setNavigationBarHidden(true, animated: false)
		subviewTypeSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primaryBG], for: .selected)

		subviewTypeSwitch.removeAllSegments()
		for (index, segment) in self.segments.enumerated() {
			subviewTypeSwitch.insertSegment(withTitle: segment, at: index, animated: true)
		}

		subviewTypeSwitch.selectedSegmentIndex = self.currentSubviewIndex
	}

	override func viewDidAppear(_ animated: Bool) {
		self.reloadSubview()
	}

	func loadMapView() {
		let map = MKMapView()

		map.mapType = .standard

		let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 59.347990, longitude: 18.071482)
		let spanSize: CLLocationDistance = 200

		let region = MKCoordinateRegion(center: center, latitudinalMeters: spanSize, longitudinalMeters: spanSize)

		map.setRegion(region, animated: true)

		let subviewFrame = self.happeningsSubview.frame
		map.frame = CGRect(x: 0, y: 0, width: subviewFrame.width, height: subviewFrame.height)

		self.happeningsSubview.addSubview(map)
	}

	func loadListView() {
		print("TODO: Load list view")
	}

	func reloadSubview() {
		//Clear all subviews
		self.happeningsSubview.subviews.forEach({$0.removeFromSuperview()})
		switch self.currentSubviewIndex {
		case 0:
			self.loadMapView()
		case 1:
			self.loadListView()
		default:
			fatalError("Not implemented \(self.currentSubviewIndex) subview type")
		}
	}
}
