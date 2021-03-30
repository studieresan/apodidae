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

	var disposeBag = DisposeBag()

	@IBOutlet weak var subviewTypeSwitch: UISegmentedControl!
	@IBOutlet weak var happeningsSubview: UIView!

	var currentSubviewIndex = 0

	@IBAction func didPressNewHappening(_ sender: Any) {
		print("new happening")
	}

	@IBAction func didSwitchSubviewType(_ sender: Any) {
		self.currentSubviewIndex = self.subviewTypeSwitch.selectedSegmentIndex
		self.reloadSubview()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		self.happeningSubviews = [
			Subview(title: "Kartvy", viewController: MapSubview()),
			Subview(title: "Listvy", viewController: ListSubview()),
		]

		self.navigationController?.setNavigationBarHidden(true, animated: false)
		subviewTypeSwitch.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.primaryBG], for: .selected)

		subviewTypeSwitch.removeAllSegments()

		for (index, segment) in self.happeningSubviews.enumerated() {
			subviewTypeSwitch.insertSegment(withTitle: segment.title, at: index, animated: true)
		}

		subviewTypeSwitch.selectedSegmentIndex = self.currentSubviewIndex

		fetchData()
	}

	override func viewDidAppear(_ animated: Bool) {
		self.setFramesOfSubviews()
		self.reloadSubview()
	}

	func fetchData() {
		Http
			.fetchHappenings()
			.subscribe(
				onNext: { [self] happenings in
					for segment in self.happeningSubviews {
						segment.viewController.onData(happenings)
					}
				}).disposed(by: self.disposeBag)
	}

	///Set the frame of all subviews as to not be bigger than their superview
	func setFramesOfSubviews() {
		self.happeningSubviews.forEach({ subview in
			subview.viewController.view.frame = self.happeningsSubview.bounds
		})
	}

	func reloadSubview() {
		//Clear all subviews
		self.happeningsSubview.subviews.forEach({$0.removeFromSuperview()})

		//Choose new subview to show
		let newSubview = self.happeningSubviews[self.currentSubviewIndex].viewController
		self.happeningsSubview.addSubview(
			newSubview.view
		)
	}
}
