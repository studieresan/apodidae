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

	//ID of currently logged in user
	var userId: String?

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
		guard let userId = self.userId,
			  let pickedEmoji = self.pickedEmoji,
			  let location = self.location else {
			let alert = UIAlertController(title: "Kan inte spara Happening", message: "Glöm inte att välja emoji och plats!", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default))
			self.present(alert, animated: true)
			return
		}

		//Describe the amount of companions
		var companionsDescription: String
		switch self.companions.count {
		case 0:
			companionsDescription = "ensam"
		case 1:
			companionsDescription = "med en annan person"
		default:
			companionsDescription = "med \(self.companions.count) andra"
		}

		let newHappening = NewHappening(
			hostId: userId,
			participants: self.companions,
			location: location,
			title: "Sitter \(companionsDescription)!",
			emoji: pickedEmoji,
			description: self.descriptionField.text
		)

		view.isUserInteractionEnabled = false

		Http.create(happening: newHappening).subscribe(onNext: { _ in
			DispatchQueue.main.async {
				self.navigationController?.popViewController(animated: true)
			}
		}, onError: { error in
			DispatchQueue.main.async {
				let alert = UIAlertController(
					title: "Fel med att skapa Happening",
					message: "\(error.localizedDescription)", preferredStyle: .alert
				)
				alert.addAction(UIAlertAction(title: "OK", style: .default))
				self.present(alert, animated: true)
				self.view.isUserInteractionEnabled = true
			}
		}).disposed(by: self.disposeBag)
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

	//Called in begining for default center, then possibly later when user location is found
	func setLocationLabel(coords: CLLocationCoordinate2D) {
		CLGeocoder().locationNameOf(coords: coords, callback: { name in
			let locationName = name ?? "Okänd plats"
			self.locationLabel.text = locationName
			self.location = GeoJSON(coordinates: coords, title: locationName)
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

	func setCompanionLabel() {
		self.companionsLabel.text = "Du sitter med \(self.companions.count) polare"
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		//Set bar title font
		self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]

		locationLabel.text = ""
		companionsLabel.text = ""

		//Cache userId
		self.userId = UserManager.getUserData()?.id

		//Fetch all users and cache them
		Http.fetchAllUsers(studsYear: AppDelegate.STUDSYEAR).subscribe(onNext: { users in
			//Sort by name
			self.allUsers = users.sorted(by: {$0.fullName() < $1.fullName()})

			//Filter out id of current user
			self.allUsers = self.allUsers.filter({!$0.isSelfUser()})

		}).disposed(by: self.disposeBag)

		self.setCompanionLabel()

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
			//Callback when location is set by other cv
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
			//Callback when selected users are set by other cv
			chooseCompanionsVC.setSelectedUsers = { users in
				self.companions = users
				self.setCompanionLabel()
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
