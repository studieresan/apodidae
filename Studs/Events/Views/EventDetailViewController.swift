//
//  EventDetailViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-17.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

final class EventDetailViewController: UIViewController {

    // MARK: Properties

    public var event: Event?

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var eventTitleMonth: UILabel!
    @IBOutlet weak var eventTitleDay: UILabel!
    @IBOutlet weak var companyName: UILabel!

    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventAddress: UILabel!

    @IBOutlet weak var descriptionText: UITextView!

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        // Show the top navigation bar in this view
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self

        closeButton.run {
            $0.setTitle("", for: .normal)
            $0.setBackgroundImage(#imageLiteral(resourceName: "closeBtn"), for: .normal)
        }

        if event != nil {
            initEventTitle()
            initDescription()
            setInitialLocation()
        }
    }

    // MARK: Actions

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapPreEvent(_ sender: Any) {
        if (event!.beforeSurveys?.count)! < 1 {
            showNoFormAlert()
            return
        }
        if let preEventUrl = event!.beforeSurveys?[0] {
            self.openUrl(url: preEventUrl)
        }
    }

    @IBAction func didTapAfterEvent(_ sender: Any) {
        if (event!.afterSurveys?.count)! < 1 {
            showNoFormAlert()
            return
        }
        if let afterEventUrl = event!.afterSurveys?[0] {
            self.openUrl(url: afterEventUrl)
        }
    }

    // MARK: Private methods

    private func initEventTitle() {
        let dateFormatter = DateFormatter()

        guard let date = event!.getDate() else {
            fatalError("Couldn't format date of event")
        }

        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: date).uppercased()

        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: date)

        eventTitleMonth.run {
            $0.textColor = UIColor.primaryDark
            $0.text = month
        }

        eventTitleDay.run {
            $0.textColor = UIColor.primaryDark
            $0.text = day
        }

        companyName.text = event!.companyName

        eventAddress.text = event!.location

        dateFormatter.dateFormat = "EEEE MMM d, HH:mm"
        let timeStamp = dateFormatter.string(from: date)
        eventTime.text = timeStamp
    }

    private func setInitialLocation() {
        guard let address = event?.location else {
            fatalError("Event location isn't set")
        }

        getCoordinate(addressString: address) { location, error in
            if error != nil {
                return
            }

            let regionRadius: CLLocationDistance = 500

            let annotation = MKPointAnnotation().apply {
                $0.coordinate = location
                $0.title = address
            }

            let coordinateRegion = MKCoordinateRegion(center: location,
                                                    latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            self.mapView.run {
                $0.addAnnotation(annotation)
                $0.setRegion(coordinateRegion, animated: false)
            }
        }
    }

    private func initDescription() {
        descriptionText.run {
            $0.text = event!.privateDescription

            // Remove textview padding
            $0.textContainerInset = UIEdgeInsets.zero
            $0.textContainer.lineFragmentPadding = 0
        }
    }

    // MARK: Helper methods

    // Shows an alert for when no survey has been added to this event
    private func showNoFormAlert() {
        let alert = UIAlertController(title: "Event survey",
                                      message: "This survey hasn't been added to this event yet", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
    }

    // Opens a specified URL in a Safari View Controller
    private func openUrl(url: String) {
        guard let url = URL(string: url) else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }

    // Converts an address to coordinates.
    // Source: https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
    private func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!

                    completionHandler(location.coordinate, nil)
                    return
                }
            }

            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }

}

extension EventDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Prevent scroll bouncing on the top of the scroll view
        if scrollView.contentOffset.y < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }

}
