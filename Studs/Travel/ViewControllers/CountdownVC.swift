//
//  CountdownVC.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-10.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import UIKit

class CountdownVC: UIViewController {

	@IBOutlet weak var remainingLabel: UILabel!
	@IBOutlet weak var emojiLabel: UILabel!

	private let TRAVELDATE = Date(timeIntervalSince1970: 1623672000)
	private let EMOJIS = "😍😇😎🥳🤩🤯😱🤠☀️🌆🌉🏖🏝✈️🚝🚆🏄🌅"

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		let now = Date()
		let calendar = Calendar(identifier: .iso8601)

		let days = calendar.dateComponents([.day], from: now, to: TRAVELDATE).day

		if days == nil {
			remainingLabel.text = "Det blev fel :("
			emojiLabel.text = "😫"
			return
		}

		remainingLabel.text = "\(days!) dagar kvar!!"
		emojiLabel.text = "\(EMOJIS.randomElement() ?? "😇")"
	}
}
