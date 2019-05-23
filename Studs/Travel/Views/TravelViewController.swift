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
        self.navigationItem.setRightBarButton(button, animated: false)
        self.title = "Trip"
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
        let bottomSheetVc = MDCBottomSheetController(contentViewController: TravelDetailsViewController())
        present(bottomSheetVc, animated: true, completion: nil)
    }
}

extension TravelViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        map.setCenter(map.userLocation.coordinate, animated: true)
        let region = MKCoordinateRegion(center: map.userLocation.coordinate, latitudinalMeters: mapSpan, longitudinalMeters: mapSpan)
        map.setRegion(region, animated: true)
    }
}
