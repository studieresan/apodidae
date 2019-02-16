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

//        selectionStyle = SelectionStyle.none

        // Set colors of elements
        contentView.backgroundColor = UIColor.bgColor
        month.textColor = UIColor.primaryColor
        day.textColor = UIColor.primaryColor

        // Add drop shadow to container view
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowColor = UIColor(rgb: 0xcbcbcb).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            // Configure the view for the selected state
            contentView.backgroundColor = UIColor.bgColor
            containerView.backgroundColor = UIColor.veryLightGray
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        contentView.backgroundColor = UIColor.bgColor
        containerView.backgroundColor = UIColor.veryLightGray
    }

}
