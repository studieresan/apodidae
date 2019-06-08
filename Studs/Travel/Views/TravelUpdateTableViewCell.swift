//
//  TravelUpdateTableViewCell.swift
//  Studs
//
//  Created by Willy Liu on 2019-05-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class TravelUpdateTableViewCell: UITableViewCell {

    // MARK: UI elements
    lazy var nameLabel: UILabel = self.setupNameLabel()
    lazy var timeLabel: UILabel = self.setupTimeLabel()
    private lazy var locationIcon: UIImageView = self.setupLocationIcon()
    lazy var locationLabel: UILabel = self.setupLocationLabel()
    lazy var contentLabel: UILabel = self.setupContentLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.run {
            $0.addSubview(nameLabel)
            $0.addSubview(timeLabel)
            $0.addSubview(locationIcon)
            $0.addSubview(locationLabel)
            $0.addSubview(contentLabel)
        }
        addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        // Name
        constraints += [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ]

        // Location icon
        constraints += [
            locationIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            locationIcon.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
        ]

        // Location
        constraints += [
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 5),
        ]

        // Message
        constraints += [
            contentLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ]

        // Time
        constraints += [
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: UI elements creators

    private func setupNameLabel() -> UILabel {
        return UILabel().apply {
            $0.text = "First Last"
            $0.numberOfLines = 0
            $0.textColor = UIColor.textColor
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupTimeLabel() -> UILabel {
        return UILabel().apply {
            $0.text = "10m"
            $0.numberOfLines = 0
            $0.textColor = UIColor(rgb: 0x8d8d8d)
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupLocationIcon() -> UIImageView {
        return UIImageView(image: UIImage(named: "locationIcon")).apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupLocationLabel() -> UILabel {
        return UILabel().apply {
            $0.text = "Location name"
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor(rgb: 0x8d8d8d)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContentLabel() -> UILabel {
        return UILabel().apply {
            $0.numberOfLines = 0
            $0.textColor = UIColor.textColor
            $0.text = "This is text."
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
