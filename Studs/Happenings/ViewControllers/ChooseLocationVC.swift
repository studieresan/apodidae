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

	var currentLocation: CLLocationCoordinate2D!

	//Function to call when the user changed the location. Set by super-viewcontroller
	var setLocation: ((_: CLLocationCoordinate2D, _: String) -> Void)!

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

	func getNameOfLocation(coords: CLLocationCoordinate2D) {
		let geoCoder = CLGeocoder()
		geoCoder.locationNameOf(coords: coords) { name in
			self.titleField.text = name ?? "Okänd plats"
		}
	}

	func generatePin(at location: CLLocationCoordinate2D) {
		let pin = MKPointAnnotation()
		pin.coordinate = location
		//Remove all annotations first
		self.mapView.annotations.forEach({self.mapView.removeAnnotation($0)})

		self.mapView.addAnnotation(pin)

		self.currentLocation = location

		self.getNameOfLocation(coords: location)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.setLocation(currentLocation, titleField.text ?? "")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.generatePin(at: mapView.centerCoordinate)

		mapView.showsUserLocation = true
		mapView.setCenter(self.currentLocation, animated: true)

		//Register long map press for pin
		let longMapPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
		longMapPress.addTarget(self, action: #selector(onLongMapPress(_:)))
		mapView.addGestureRecognizer(longMapPress)
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
