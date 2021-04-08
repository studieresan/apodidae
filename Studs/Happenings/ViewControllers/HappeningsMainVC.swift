//
//  HappeningsMainVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2021-03-30.
//  Copyright © 2021 Studieresan. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RxSwift

//TODO: Cache mapview and listview as to not have to rerender them at every switch
class HappeningsMainVC: UIViewController {

	struct Subview {
		let title: String
		let viewController: HappeningsSubview
	}

	//Each segment title with its corresponding subview view
	var happeningSubviews: [Subview] = []

	var mapSubview = MapSubview()
	var listSubview: ListSubview!

	var disposeBag = DisposeBag()

	@IBOutlet weak var subviewTypeSwitch: UISegmentedControl!
	@IBOutlet weak var happeningsSubview: UIView!

	@IBAction func didPressNewHappening(_ sender: Any) {
		print("new happening")
	}

	@IBAction func didSwitchSubviewType(_ sender: Any) {
		self.reloadSubview()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let listSubview = UIStoryboard(name: "HappeningsMainView", bundle: nil)
				.instantiateViewController(withIdentifier: "happenings-list-controller") as? ListSubview else {
			fatalError("Could not find happenings-list-controller")
		}
		self.listSubview = listSubview

		//When a happening cell is pressed, center on it in the map
		self.listSubview.onCellPressed = centerOnHappening

		self.listSubview.onUpdateData = self.fetchData

		self.happeningSubviews = [
			Subview(title: "Kartvy", viewController: self.mapSubview),
			Subview(title: "Listvy", viewController: self.listSubview),
		]

		self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]

		subviewTypeSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primaryBG], for: .selected)

		subviewTypeSwitch.removeAllSegments()

		for (index, segment) in self.happeningSubviews.enumerated() {
			subviewTypeSwitch.insertSegment(withTitle: segment.title, at: index, animated: true)
		}

		subviewTypeSwitch.selectedSegmentIndex = 0

		fetchData()
	}

	override func viewDidAppear(_ animated: Bool) {
		self.setFramesOfSubviews()
		self.reloadSubview()
		self.fetchData()
	}

	func centerOnHappening(_ happening: Happening) {
		//Switch to map
		self.subviewTypeSwitch.selectedSegmentIndex = 0
		self.reloadSubview()
		self.mapSubview.centerOn(happening: happening)
	}

	///Fetch data with a callback when done
	func fetchData(callback: ((_: Error?) -> Void)? = nil) {
		Http
			.fetchHappenings()
			.subscribe(
				onNext: { [self] happenings in
					for segment in self.happeningSubviews {
						segment.viewController.onData(happenings)
					}
					if callback != nil {
						//If callback, call with nil error
						callback!(nil)
					}
				}, onError: { error in
					//If error, callback with error
					if callback != nil {
						callback!(error)
					}
				}).disposed(by: self.disposeBag)
	}

	///Set the frame of all subviews as to not be bigger than their superview
	func setFramesOfSubviews() {
		self.happeningSubviews.forEach({ subview in
			subview.viewController.view.frame = self.happeningsSubview.bounds
		})
	}

	///Set the subview depending on what the value of the switch is
	func reloadSubview() {
		//Clear all subviews
		self.happeningsSubview.subviews.forEach({$0.removeFromSuperview()})

		//Choose new subview to show
		let newSubview = self.happeningSubviews[self.subviewTypeSwitch.selectedSegmentIndex].viewController
		self.happeningsSubview.addSubview(
			newSubview.view
		)
	}
}
