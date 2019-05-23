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

    private lazy var nameLabel: UILabel = self.setupNameLabel()
    private lazy var timeLabel: UILabel = self.setupTimeLabel()
    private lazy var locationIcon: UIImageView = self.setupLocationIcon()
    private lazy var locationLabel: UILabel = self.setupLocationLabel()
    private lazy var contentLabel: UILabel = self.setupContentLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(nameLabel)
        self.addSubview(timeLabel)
        self.addSubview(locationIcon)
        self.addSubview(locationLabel)
        self.addSubview(contentLabel)

        addConstraints()
        setNeedsLayout()
        layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        constraints += [
            contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            locationIcon.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            locationIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationIcon.heightAnchor.constraint(equalToConstant: 15),
            locationIcon.widthAnchor.constraint(equalToConstant: 14),
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 4),
            contentLabel.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: 14),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: UI elements creators

    private func setupNameLabel() -> UILabel {
        return UILabel().apply {
            $0.text = "Andreas Heiskanen"
            $0.numberOfLines = 0
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
            $0.text = "Sushi Inoue"
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = UIColor(rgb: 0x8d8d8d)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupContentLabel() -> UILabel {
        return UILabel().apply {
            $0.numberOfLines = 0
            $0.text = "Nån som vill äta på Michelin-restaurang?"
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
