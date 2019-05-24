//
//  TravelDetailsViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-05-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class TravelDetailsViewController: UIViewController {

    // MARK: UI Elements

    private lazy var dragIndicatorView: UIView = self.setupDragIndicatorView()
    private lazy var titleLabel: UILabel = self.setupTitleLabel()
    private lazy var navButtonsStackView: UIStackView = self.setupButtonsStackView()
    private lazy var housingBtn: UIButton = self.setupHousingBtn()
    private lazy var contactsBtn: UIButton = self.setupContactsBtn()
    private lazy var separator: UIView = self.setupSeparatorLine()
    private lazy var updateTitleLabel: UILabel = self.setupUpdateTitleLabel()
    private lazy var tableTopBorder: UIView = self.setupTableTopBorder()
    private lazy var updateFeedTable: UITableView = self.setupUpdateFeedTable()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(dragIndicatorView)
        view.addSubview(titleLabel)
        view.addSubview(navButtonsStackView)
        navButtonsStackView.addArrangedSubview(housingBtn)
        navButtonsStackView.addArrangedSubview(contactsBtn)
        if #available(iOS 11.0, *) {
            navButtonsStackView.setCustomSpacing(10, after: housingBtn)
        }
        view.addSubview(separator)
        view.addSubview(updateTitleLabel)
        view.addSubview(tableTopBorder)
        view.addSubview(updateFeedTable)
        updateFeedTable.delegate = self
        updateFeedTable.dataSource = self
        updateFeedTable.register(TravelUpdateTableViewCell.self, forCellReuseIdentifier: "travelCell")

        addConstraints()
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        // Drag indicator
        constraints += [
            dragIndicatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            dragIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dragIndicatorView.widthAnchor.constraint(equalToConstant: 30),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: 5),
        ]

        // Title
        constraints += [
            titleLabel.topAnchor.constraint(equalTo: dragIndicatorView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]

        // Buttons stack view and buttons
        constraints += [
            navButtonsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            navButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            housingBtn.heightAnchor.constraint(equalToConstant: 40),
            contactsBtn.heightAnchor.constraint(equalToConstant: 40),
        ]

        // Section separator line
        constraints += [
            separator.heightAnchor.constraint(equalToConstant: 4),
            separator.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            separator.topAnchor.constraint(equalTo: navButtonsStackView.bottomAnchor, constant: 24),
        ]

        // "Updates" label
        constraints += [
            updateTitleLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 14),
            updateTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableTopBorder.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableTopBorder.heightAnchor.constraint(equalToConstant: 1),
            tableTopBorder.bottomAnchor.constraint(equalTo: updateFeedTable.topAnchor),
        ]

        // Updates table
        constraints += [
            updateFeedTable.topAnchor.constraint(equalTo: updateTitleLabel.bottomAnchor, constant: 14),
            updateFeedTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            updateFeedTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            updateFeedTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: UI Element creators

    private func setupDragIndicatorView() -> UIView {
        return UIView().apply {
            $0.backgroundColor = UIColor(rgb: 0xd8d8d8)
            $0.layer.cornerRadius = 2.5
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupTitleLabel() -> UILabel {
        return UILabel().apply {
            $0.text = "Travel info"
            $0.textColor = UIColor.textColor
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupButtonsStackView() -> UIStackView {
        return UIStackView().apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            $0.isLayoutMarginsRelativeArrangement = true
        }
    }

    private func setupHousingBtn() -> UIButton {
        return StudsButton().apply {
            $0.setTitle("Housing", for: .normal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(displayHousingInfo), for: .touchUpInside)
        }
    }

    private func setupContactsBtn() -> UIButton {
        return StudsButton().apply {
            $0.setTitle("Contacts", for: .normal)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(displayContactInfo), for: .touchUpInside)
        }
    }

    private func setupSeparatorLine() -> UIView {
        return UIView().apply {
            $0.backgroundColor = UIColor(rgb: 0xeff4f6)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupUpdateTitleLabel() -> UILabel {
        return UILabel().apply {
            $0.text = "Updates"
            $0.textColor = UIColor.textColor
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupTableTopBorder() -> UIView {
        return UIView().apply {
            $0.backgroundColor = UIColor(rgb: 0xeff4f6)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupUpdateFeedTable() -> UITableView {
        return UITableView().apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    @objc private func displayHousingInfo() {
        print("Display housing")
    }

    @objc private func displayContactInfo() {
        print("Display contact")
    }
}

extension TravelDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as? TravelUpdateTableViewCell else {
            fatalError("Table cell not of type TravelUpdateTableViewCell")
        }

        return cell
    }
}
