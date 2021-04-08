//
//  HappeningNewVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-04-06.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RxSwift

class HappeningNewViewController: UIViewController {

	//Cache request of all users
	var allUsers: [User] = []

	var pickedEmoji: String?
	var location: GeoJSON?
	var companions: [User] = []

	var locationManager = CLLocationManager()

	var disposeBag = DisposeBag()

	@IBOutlet var emojiButtons: [UIButton]!

	@IBOutlet var locationLabel: UILabel!

	@IBOutlet var descriptionField: UITextView!

	@IBOutlet var companionsLabel: UILabel!

	@IBAction func saveButtonPressed(_ sender: Any) {
		print("SAVE")
	}

	@objc func hideKeyboard() {
		self.view.endEditing(true)
	}

	@IBAction func emojiButtonPressed(_ sender: Any) {
		for emojiButton in self.emojiButtons {
			if let pressedButton = sender as? UIButton {
				if pressedButton == emojiButton {
					emojiButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)

					self.pickedEmoji = emojiButton.titleLabel?.text
				} else { //Not pressed, change to smaller font
					emojiButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
				}
			}
		}
	}

	func setLocationLabel(coords: CLLocationCoordinate2D) {
		CLGeocoder().locationNameOf(coords: coords, callback: { name in
			self.locationLabel.text = name ?? "Okänd plats"
		})
	}

	func findStartLocation() {
		locationManager.delegate = self
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestWhenInUseAuthorization()
			locationManager.startUpdatingLocation()
		} else {
			setLocationLabel(coords: MKMapView.defaultCenter)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		//Set bar title font
		self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]

		locationLabel.text = ""
		companionsLabel.text = ""

		//Fetch all users and cache them
		Http.fetchAllUsers(studsYear: AppDelegate.STUDSYEAR).subscribe(onNext: { users in
			//Sort by name
			self.allUsers = users.sorted(by: {$0.fullName() < $1.fullName()})
		}).disposed(by: self.disposeBag)

		findStartLocation()
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.hideKeyboard()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case "change-location":
			guard let chooseLocationVC = segue.destination as? ChooseLocationViewController else {
				print("VC is not correct! (change-location)")
				return
			}
			chooseLocationVC.currentLocation = self.location?.coordinate()
			chooseLocationVC.setLocation = { location, title in
				self.location = GeoJSON(coordinates: location, title: title)
				self.locationLabel.text = title
			}

		case "change-companions":
			guard let chooseCompanionsVC = segue.destination as? ChooseCompanionsViewController else {
				print("VC is not correct! (change-location)")
				return
			}
			chooseCompanionsVC.allUsers = self.allUsers
			//Create as set as this is needed in VC
			chooseCompanionsVC.selectedUsers = Set(self.companions)
			chooseCompanionsVC.setSelectedUsers = { users in
				self.companions = users
				self.companionsLabel.text = "Du sitter med \(users.count) polare"
			}

		default:
			return
		}
	}
}

extension HappeningNewViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		//Only get user location once
		if let currentLocation = locations.last {
			self.locationManager.stopUpdatingLocation()

			let location = currentLocation.coordinate

			self.setLocationLabel(coords: location)
		}
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status != .authorizedAlways || status != .authorizedWhenInUse {
			self.setLocationLabel(coords: MKMapView.defaultCenter)
		}
	}

}
