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

    private lazy var titleLabel: UILabel = self.setupTitleLabel()
    private lazy var navButtonsStackView: UIStackView = self.setupButtonsStackView()
    private lazy var housingBtn: UIButton = self.setupHousingBtn()
    private lazy var contactsBtn: UIButton = self.setupContactsBtn()
    private lazy var separator: UIView = self.setupSeparatorLine()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(navButtonsStackView)
        navButtonsStackView.addArrangedSubview(housingBtn)
        navButtonsStackView.addArrangedSubview(contactsBtn)
        if #available(iOS 11.0, *) {
            navButtonsStackView.setCustomSpacing(10, after: housingBtn)
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(separator)

        addConstraints()
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        constraints += [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navButtonsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            navButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            housingBtn.heightAnchor.constraint(equalToConstant: 40),
            contactsBtn.heightAnchor.constraint(equalToConstant: 40),
            separator.heightAnchor.constraint(equalToConstant: 4),
            separator.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            separator.topAnchor.constraint(equalTo: navButtonsStackView.bottomAnchor, constant: 24),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func setupTitleLabel() -> UILabel {
        let label = UILabel().apply {
            $0.text = "Travel info"
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return label
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
        }
    }

    private func setupContactsBtn() -> UIButton {
        return StudsButton().apply {
            $0.setTitle("Contacts", for: .normal)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupSeparatorLine() -> UIView {
        return UIView().apply {
            $0.backgroundColor = UIColor(rgb: 0xeff4f6)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
