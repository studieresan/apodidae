//
//  ChooseLocationVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-07.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ChooseLocationViewController: UIViewController {

	@IBOutlet var mapView: MKMapView!
	@IBOutlet var titleField: UITextField!

	var locationManager = CLLocationManager()

	@IBAction func onDonePressed(_ sender: Any) {
		self.dismiss(animated: true)
	}

	@objc func onLongMapPress(_ sender: UILongPressGestureRecognizer) {
		//If just started, just return as to not create many pins
		guard sender.state != .began else {
			return
		}

		let pressLocation = sender.location(in: self.mapView)
		let locationCoordinate = self.mapView.convert(pressLocation, toCoordinateFrom: self.mapView)

		self.generatePin(at: locationCoordinate)

	}

	func generatePin(at location: CLLocationCoordinate2D) {
		let pin = MKPointAnnotation()
		pin.coordinate = location
		//Remove all annotations first
		self.mapView.annotations.forEach({self.mapView.removeAnnotation($0)})

		self.mapView.addAnnotation(pin)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		mapView.resetDefaultCenter()

		locationManager.delegate = self
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestWhenInUseAuthorization()
			locationManager.startUpdatingLocation()
		} else {
			print("No location enabled")
		}

		mapView.showsUserLocation = true

		//Register long map press for pin
		let longMapPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
		longMapPress.addTarget(self, action: #selector(onLongMapPress(_:)))
		mapView.addGestureRecognizer(longMapPress)
	}
}

extension ChooseLocationViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		//Only center the map once, when we get the users location
		if let currentLocation = locations.last {
			self.locationManager.stopUpdatingLocation()

			let center = currentLocation.coordinate

			self.mapView.setCenter(center, animated: true)
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error with location: \(error)")
	}
}

extension ChooseLocationViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		let identifier = "LocationPin"

		let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

		pinView.animatesDrop = true
		pinView.annotation = annotation

		return pinView
	}
}
