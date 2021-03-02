//
//  EventTableViewCell.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-10.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set colors of elements
        contentView.backgroundColor = UIColor.secondaryBG
        month.textColor = UIColor.primary
        day.textColor = UIColor.primary

        // Add drop shadow to container view
        containerView.layer.run {
            $0.shadowRadius = 2
            $0.shadowOpacity = 1
			$0.shadowColor = UIColor.shadow.cgColor
            $0.shadowOffset = CGSize(width: 0, height: 2)
            $0.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        }
    }

	// To change shadow color on appearance switch. Courtesy of https://stackoverflow.com/questions/58092716/uiviews-shadowpath-color-doesnt-change
	override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
			containerView.layer.run {
				$0.shadowColor = UIColor.shadow.cgColor
			}
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            // Configure the view for the selected state
            contentView.backgroundColor = UIColor.primaryBG
            containerView.backgroundColor = UIColor.veryLightGray
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        contentView.backgroundColor = UIColor.primaryBG
        containerView.backgroundColor = UIColor.veryLightGray
    }
}
