//
//  TravelViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit
import MapKit
import MaterialComponents.MaterialBottomSheet

final class TravelViewController: UIViewController {

    // MARK: Properties

    private let mapSpan: CLLocationDistance = 500
    private var locationManager: CLLocationManager!
    private var hasZoomedInMap = false
    private let viewModel = TravelViewModel()
    private var userToAnnotationMap: [String: MKAnnotation] = [:]

    // MARK: UI Elements

    private lazy var map: MKMapView = self.setupMap()

    // MARK: Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        super.modalPresentationStyle = .fullScreen
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(map)
        let button = UIBarButtonItem(title: "Details", style: .plain, target: self, action: #selector(showBottomSheet))
        self.navigationItem.setLeftBarButton(MKUserTrackingBarButtonItem(mapView: map), animated: false)
        self.navigationItem.setRightBarButton(button, animated: false)
        self.title = "Travel"

        map.delegate = self

        addConstraints()

        viewModel.delegate = self
        viewModel.setupLiveLocationListener()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

    deinit {
        viewModel.removeLiveLocationListener()
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        constraints += [
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func fetchUserLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    @objc private func showBottomSheet() {
        let detailsVC = TravelDetailsViewController().apply {
            $0.previousVC = self
        }
        let bottomSheetVc = MDCBottomSheetController(contentViewController: detailsVC)
        let distanceFromTop: CGFloat = 120
        bottomSheetVc.preferredContentSize = CGSize(width: view.frame.width, height: view.frame.height - distanceFromTop)
        present(bottomSheetVc, animated: true, completion: nil)
    }

    func addMapAnnotation(latitude: Double, longitude: Double, nameOfPerson: String, locationName: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation().apply {
            $0.coordinate = coordinate
            $0.title = "\(nameOfPerson): \(locationName)"
        }

        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)

        map.run {
            $0.addAnnotation(annotation)
            $0.setRegion(coordinateRegion, animated: true)
        }
    }

    // MARK: UI Element creators

    private func setupMap() -> MKMapView {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        return mapView
    }

}

extension TravelViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]

        // Only zoom in on user once
        if !hasZoomedInMap {
            map.setCenter(currentLocation.coordinate, animated: true)
            let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: mapSpan, longitudinalMeters: mapSpan)
            map.setRegion(region, animated: false)
            hasZoomedInMap = true
        }

        // Update own live location if allowed
        if UserManager.getShouldShareLiveLocation() {
            let username = (UserManager.getUserData()?.name)!
            let location = LastKnownLocation(
                user: username,
                lat: currentLocation.coordinate.latitude,
                lng: currentLocation.coordinate.longitude
            )

            viewModel.updateOwnLiveLocation(currentLocation: location)
        }

    }

}

extension TravelViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .infoDark)
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard
            let coordinate = view.annotation?.coordinate,
            let name = view.annotation?.title
        else {
            return
        }

        let alert = UIAlertController(
            title: "Show directions in Maps?",
            message: "Open the Maps app and show directions to this location",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Show directions", style: .default) { _ in
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate)).apply {
                $0.name = name
            }
            destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension TravelViewController: TravelViewModelDelegate {

    func onNewLiveLocation(latestLocation: LastKnownLocation) {
        if let previousAnnotationForUser = userToAnnotationMap[latestLocation.user] {
            self.map.removeAnnotation(previousAnnotationForUser)
        }
        let newAnnotation = MKPointAnnotation().apply {
            $0.coordinate = CLLocationCoordinate2D(latitude: latestLocation.lat, longitude: latestLocation.lng)
            $0.title = "\(latestLocation.user)'s last position"
        }
        userToAnnotationMap[latestLocation.user] = newAnnotation
        self.map.addAnnotation(newAnnotation)
    }

}
