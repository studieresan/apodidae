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

    private let mapSpan: CLLocationDistance = 500

    private lazy var map: MKMapView = self.setupMap()

    private var locationManager: CLLocationManager!

    private var hasZoomedInMap = false

    init() {
        super.init(nibName: nil, bundle: nil)
        super.modalPresentationStyle = .fullScreen
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupMap() -> MKMapView {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        return mapView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(map)
        let button = UIBarButtonItem(title: "Details", style: .plain, target: self, action: #selector(showBottomSheet))
        self.navigationItem.setLeftBarButton(MKUserTrackingBarButtonItem(mapView: map), animated: false)
        self.navigationItem.setRightBarButton(button, animated: false)
        self.title = "Travel"
        addConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
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
}

extension TravelViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only zoom in on user once
        if !hasZoomedInMap {
            map.setCenter(map.userLocation.coordinate, animated: true)
            let region = MKCoordinateRegion(center: map.userLocation.coordinate, latitudinalMeters: mapSpan, longitudinalMeters: mapSpan)
            map.setRegion(region, animated: true)
            hasZoomedInMap = true
        }
    }

}
