//
//  MapSubview.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import MapKit

class MapSubview: UIViewController, HappeningsSubview {
	var happenings: [Happening] = []

	var center = MKMapView.defaultCenter
	var span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: MKMapView.defaultDelta, longitudeDelta: MKMapView.defaultDelta)

	let locationManager = CLLocationManager()

	var mapView: MKMapView = MKMapView()

	func onData(_ happenings: [Happening]) {
		self.happenings = happenings
		self.reloadView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let view = mapView

		view.delegate = self
		view.mapType = .standard

		view.showsUserLocation = true

		locationManager.delegate = self
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestWhenInUseAuthorization()
			locationManager.startUpdatingLocation()
		} else {
			print("No location enabled")
		}

		view.clipsToBounds = true

		self.view = view

		mapView.resetDefaultCenter()
	}

	//Show all happenings on map
	func reloadView() {
		//Clear all current annotations
		for annotation in self.mapView.annotations {
			self.mapView.removeAnnotation(annotation)
		}
		DispatchQueue.main.async {
		//Add all happening annotations
			for happening in self.happenings {
				let location = happening.location.coordinate()

				let annotation = MKPointAnnotation()

				annotation.title = happening.emoji
				annotation.subtitle = happening.title

				annotation.coordinate = location

				self.mapView.addAnnotation(annotation)
			}
		}
	}

	//Center map to current center
	func reCenterMap() {
		let region = MKCoordinateRegion(center: center, span: self.span)

		mapView.setRegion(region, animated: true)
	}
}

extension MapSubview: MKMapViewDelegate {
	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		let span = mapView.region.span
		self.span = span
	}
}

extension MapSubview: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		//Only center the map once, when we get the users location
		if let currentLocation = locations.last {
			self.center = currentLocation.coordinate
			self.reCenterMap()
			self.locationManager.stopUpdatingLocation()
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error with location: \(error)")
	}
}
