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

		//Register happening annotation view
		mapView.register(HappeningMapAnnotationView.self, forAnnotationViewWithReuseIdentifier: HappeningMapAnnotationView.reuseIdentifier)
	}

	func centerOn(happening: Happening) {
		self.mapView.setCenter(happening.location.coordinate(), animated: true)
	}

	//Show all happenings on map
	func reloadView() {
		//Clear all current annotations
		var annotationsToRemove: [MKAnnotation] = []
		for annotation in self.mapView.annotations {
			annotationsToRemove.append(annotation)
		}
		DispatchQueue.main.async {
			//Must be removed on main thread
			self.mapView.removeAnnotations(annotationsToRemove)
		//Add all happening annotations
			for happening in self.happenings {

				let annotation = HappeningMapAnnotation(happening: happening)

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

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? HappeningMapAnnotation,
			  let annotationView = mapView
				.dequeueReusableAnnotationView(withIdentifier: HappeningMapAnnotationView.reuseIdentifier, for: annotation)
				as? HappeningMapAnnotationView else {
			return nil
		}

		return annotationView
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

class HappeningMapAnnotation: MKPointAnnotation {

	let happening: Happening

	init(happening: Happening) {
		self.happening = happening
		super.init()

		self.coordinate = happening.location.coordinate()
	}
}

class HappeningMapAnnotationView: MKAnnotationView {
	static let reuseIdentifier = "HappeningMapAnnotation"

	let size: CGFloat = 50
	//The border of the image
	let borderSize: CGFloat = 1

	lazy var imageView: UIImageView = UIImageView(image: nil)

	lazy var badge: UILabel = UILabel()

	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

		self.backgroundColor = .black

		self.frame.size = CGSize(width: self.size, height: self.size)

		self.addSubview(self.imageView)

		//Make both outer view and image view round
		self.layer.cornerRadius = self.size / 2
		self.layer.masksToBounds = true
		self.imageView.layer.cornerRadius = self.size / 2
		self.imageView.layer.masksToBounds = true

		//Set image view to almost at other anchors, diffing by borderSize pixels (i.e. creating a border of that size)
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.borderSize).isActive = true
		self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.borderSize).isActive = true
		self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: self.borderSize).isActive = true
		self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -self.borderSize).isActive = true

		
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		self.imageView.image = nil
	}

	override func prepareForDisplay() {
		super.prepareForDisplay()
		guard let annotation = self.annotation as? HappeningMapAnnotation else {
			print("Annotation not HappeningMapAnnotation")
			return
		}

		print("Prepare for display")

		imageView.imageFromURL(urlString: annotation.happening.host.picture ?? "")
	}
}
