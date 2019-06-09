//
//  TravelDetailsViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-05-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons

final class TravelDetailsViewController: UIViewController {

    private let viewModel = TravelDetailsViewModel()

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
    private lazy var newUpdateBtn: UIButton = self.setupNewUpdateBtn()

    private var viewFrame: CGRect?

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
        view.addSubview(newUpdateBtn)
        updateFeedTable.delegate = self
        updateFeedTable.dataSource = self
        updateFeedTable.register(TravelUpdateTableViewCell.self, forCellReuseIdentifier: "travelCell")

        viewModel.delegate = self
    }

    override func viewSafeAreaInsetsDidChange() {
        addConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        if let frame = self.viewFrame {
            view.frame = frame
        }
        viewModel.setupDbListener()
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Presenting a modal VC from this bottom sheet causes the size of this view
        // to change when when dismissing the view (it becomes too tall).
        // To get around this, we save the view frame before presenting the new view
        // and then restore the size when this view appears again
        self.viewFrame = view.frame

        viewModel.removeDbListeners()
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

        // New update button
        var bottomConstant = CGFloat(integerLiteral: -18)
        if #available(iOS 11.0, *) {
            let bottomInset = view.safeAreaInsets.bottom
            bottomConstant -= bottomInset
        }

        constraints += [
            newUpdateBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant),
            newUpdateBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
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

    private func setupNewUpdateBtn() -> UIButton {
        return MDCFloatingButton().apply {
            let image = UIImage(named: "newUpdateIcon")
            $0.setImage(image, for: .normal)
            $0.backgroundColor = UIColor.primary
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(showNewPostScreen), for: .touchUpInside)
        }
    }

    // MARK: Actions

    @objc private func showNewPostScreen() {
        let statusVC = StatusUpdateViewController()
        let navVC = UINavigationController(rootViewController: statusVC)
        present(navVC, animated: true, completion: nil)
    }

    @objc private func displayHousingInfo() {
        let htmlFile = Bundle.main.path(forResource: "housing_info", ofType: "html")
        if let htmlString = try? NSString(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8.rawValue) {
            present(TravelInfoViewController(html: htmlString as String), animated: true)
        }
    }

    @objc private func displayContactInfo() {
        let htmlFile = Bundle.main.path(forResource: "contact_info", ofType: "html")
        if let htmlString = try? NSString(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8.rawValue) {
            present(TravelInfoViewController(html: htmlString as String), animated: true)
        }
    }
}

extension TravelDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFeedItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as? TravelUpdateTableViewCell else {
            fatalError("Table cell not of type TravelUpdateTableViewCell")
        }

        let data = viewModel.getFeedItem(forIndexPath: indexPath)
        cell.profilePic.imageFromURL(urlString: data.picture)
        cell.nameLabel.text = data.user
        cell.contentLabel.text = data.message
        cell.timeLabel.text = data.timeFromNow()

        // If no location, display "-" instead
        if data.locationName.trimmingCharacters(in: .whitespaces) != "" {
            cell.locationLabel.text = data.locationName
        } else {
            cell.locationLabel.text = "-"
        }

        return cell
    }
}

extension TravelDetailsViewController: TravelDetailsViewModelDelegate {

    func onNewValues() {
        DispatchQueue.main.async {
            self.updateFeedTable.reloadData()
        }
    }

}
