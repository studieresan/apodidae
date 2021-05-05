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

    public var event: Event!

	//Image view controllers when user is not logged in
	var images: [UIViewController] = []

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var eventTitleMonth: UILabel!
    @IBOutlet weak var eventTitleDay: UILabel!
    @IBOutlet weak var companyName: UILabel!

    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventAddress: UILabel!

    @IBOutlet weak var descriptionText: UITextView!

	@IBOutlet weak var eventInformation: UIView!
	@IBOutlet weak var surveysView: UIView!

	@IBOutlet weak var headerView: UIView!

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the top navigation bar in this view
        navigationController?.setNavigationBarHidden(false, animated: animated)
        setTabBarVisible(visible: false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setTabBarVisible(visible: true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
		scrollView.contentOffset.y = 0

		initEventTitle()
		initDescription()

		//If we are not logged in, don't show info such as exact location or internal surveys
		if !UserManager.isLoggedIn() {
			mapView.removeFromSuperview()
			surveysView.removeFromSuperview()
			eventInformation.removeFromSuperview()

			setupImageGallery()
		} else { //If we are logged in, init the map things
			setInitialLocation()
		}

		self.title = event?.company?.name
        setUpClickListeners()
    }

	///Guaranteed to return non-empty list
	private func createFallbackGallery() -> [UIViewController] {
		let viewController = UIViewController()

		let label = UILabel()
		label.text = "Inga bilder tillgängliga"

		let view: UIView = viewController.view
		view.addSubview(label)

		label.translatesAutoresizingMaskIntoConstraints = false

		label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

		return [viewController]
	}

	private func setupImageGallery() {
		// For all image urls, create an image view and download the image to this
		self.images = event.pictures?.map({imageURL in
			let view = UIImageView()
			view.imageFromURL(urlString: imageURL)

			view.contentMode = .scaleAspectFit

			let viewController = UIViewController()

			viewController.view = view

			return viewController
		}) ?? self.createFallbackGallery() // if pictures is null, create fallback gallery
		//If there are no images, create fallback gallery
		if self.images.count < 1 {
			self.images = self.createFallbackGallery()
		}

		let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

		pageController.dataSource = self
		pageController.delegate = self

		self.headerView.addSubview(pageController.view)
		self.addChild(pageController)



		pageController.view.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)

		//Can do unsafe unwrapp as we know by previous statement that count >= 1
		pageController.setViewControllers([self.images.first!], direction: .forward, animated: true, completion: nil)

		pageController.didMove(toParent: self)
	}

    private func setUpClickListeners() {
        eventAddress.run {
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showMapDirections)))
        }
    }

    @objc
    private func showMapDirections() {
        guard let address = event?.location else {
			print("Event location isn't set")
			return
        }

        getCoordinate(addressString: address) { [weak self] coordinate, err in
            guard err == nil else { return }

            let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate)).apply {
				$0.name = self?.event?.company?.name
            }

            destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault])
        }
    }

    // MARK: Actions
    @IBAction func didTapPreEvent(_ sender: Any) {
		guard let preEventUrl = event?.beforeSurvey else {
			showNoFormAlert()
			return
		}
		self.openUrl(url: preEventUrl)
    }

    @IBAction func didTapAfterEvent(_ sender: Any) {
		guard let afterEventUrl = event!.afterSurvey else {
			showNoFormAlert()
			return
		}
		self.openUrl(url: afterEventUrl)
    }

    // MARK: Private methods

    private func initEventTitle() {
        let dateFormatter = DateFormatter()

        let date = event.date

		dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: date).uppercased()

        dateFormatter.dateFormat = "d"
        let day = dateFormatter.string(from: date)

        eventTitleMonth.run {
            $0.textColor = UIColor.primary
            $0.text = month
        }

        eventTitleDay.run {
            $0.textColor = UIColor.primary
            $0.text = day
        }

		companyName.text = event!.company?.name ?? "Okänt företag"

        eventAddress.text = event!.location

        dateFormatter.dateFormat = "EEEE MMM d, HH:mm"
        let timeStamp = dateFormatter.string(from: date)
        eventTime.text = timeStamp
    }

    private func setInitialLocation() {
        guard let address = event?.location else {
            print("Event location isn't set")
			return
        }

		//If digital, don't find the coords
		if address == "Zoom" {
			return
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
			$0.text = UserManager.isLoggedIn() ? event.privateDescription :
				event.publicDescription
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

extension EventDetailViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	func pageViewController(
		_ pageViewController: UIPageViewController,
		viewControllerBefore viewController: UIViewController
	) -> UIViewController? {
		// Fail safe if only one image to controll. Looks weird to have the same one loop then
		if self.images.count == 1 {
			return nil
		}
		let newIndex = self.images.firstIndex(of: viewController)! - 1
		let elem = newIndex < self.images.startIndex ? self.images.last! : self.images[newIndex]
		return elem
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		// Fail safe if only one image to controll. Looks weird to have the same one loop then
		if self.images.count == 1 {
			return nil
		}
		let newIndex = self.images.firstIndex(of: viewController)! + 1
		let elem = newIndex >= self.images.endIndex ? self.images.first! : self.images[newIndex]
		return elem
	}
}
