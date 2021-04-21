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

//A map annotation view that shows an image of the host as the marker, and if they have
//companions also a round badge at the upper-right corner with how many they sit with
class HappeningMapAnnotationView: MKAnnotationView {
	static let reuseIdentifier = "HappeningMapAnnotation"

	let imageSize: CGFloat = 50
	let badgeSize: CGFloat = 20
	//The border of the image
	let borderSize: CGFloat = 1

	lazy var imageView: UIImageView = UIImageView(image: nil)

	//Shows how many companions are at the happening
	lazy var badgeLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	lazy var badgeView: UIView = {
		let view = UIView()

		view.addSubview(self.badgeLabel)

		return view
	}()

	lazy var calloutVC: HappeningAnnotationCallout? = nil

	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

		self.frame.size = CGSize(width: self.imageSize, height: self.imageSize)

		self.addSubview(self.imageView)

		//Make image view round and have border
		self.imageView.layer.cornerRadius = self.imageSize / 2
		self.imageView.layer.masksToBounds = true
		self.imageView.layer.borderWidth = self.borderSize

		//Set image view to at other anchors, as to fill the view
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

		self.addSubview(badgeView)

		//Place badge at upper-right corner of marker
		self.badgeView.frame = CGRect(
			x: self.imageSize - (3/4 * self.badgeSize),
			y: (-1/4) * self.badgeSize,
			width: self.badgeSize,
			height: self.badgeSize
		)

		//Create round border around badge
		self.badgeView.layer.borderWidth = 1
		self.badgeView.layer.cornerRadius = self.badgeSize / 2

		//Center badge label inside badgeView
		self.badgeLabel.translatesAutoresizingMaskIntoConstraints = false
		self.badgeLabel.centerXAnchor.constraint(equalTo: self.badgeView.centerXAnchor).isActive = true
		self.badgeLabel.centerYAnchor.constraint(equalTo: self.badgeView.centerYAnchor).isActive = true

		self.canShowCallout = true

		//Set bolor depending on if darkmode is available or not
		if #available(iOS 13, *) {
			self.badgeView.backgroundColor = .systemGray6
			self.badgeView.layer.borderColor = UIColor.label.cgColor
		} else {
			self.badgeView.backgroundColor = .white
		}
		self.badgeLabel.font = .preferredFont(forTextStyle: .caption2)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		//Reset all stored attributes
		self.imageView.image = nil
		self.badgeLabel.text = nil
		self.calloutVC = nil
	}

	override func prepareForDisplay() {
		super.prepareForDisplay()
		guard let annotation = self.annotation as? HappeningMapAnnotation else {
			print("Annotation not HappeningMapAnnotation")
			return
		}

		let happening = annotation.happening

		imageView.imageFromURL(urlString: happening.host.picture ?? "")

		//If not initilized, try to init
		if self.calloutVC == nil {
			self.calloutVC = UIViewController
				.instance(withName: "HappeningsMainView", id: HappeningAnnotationCallout.identifier)
			 as? HappeningAnnotationCallout
		}

		if let calloutVC = self.calloutVC {
			calloutVC.happening = happening
			self.detailCalloutAccessoryView = calloutVC.view
		} else {
			let calloutLabel = UILabel()
			calloutLabel.text = "\(happening.host.firstName) är med \(happening.participants?.count ?? 0) andra på \(happening.location.title)"
			self.detailCalloutAccessoryView = calloutLabel
		}

		//If there are participants, show badge as well. Else hide badge
		if let count = happening.participants?.count, count > 0 {
			self.badgeView.isHidden = false
			self.badgeLabel.text = "+\(count)"
		} else {
			self.badgeView.isHidden = true
		}
	}
}
