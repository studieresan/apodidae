//
//  AboutViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {

    // MARK: UI Elements

    private lazy var settingsTable: UITableView = self.setupSettingsTable()
    private lazy var liveLocationCell: UITableViewCell = self.setupLiveLocationToggle()

    // MARK: Properties

    private let sectionTitles = ["Live location"]
    private let sectionFooters = ["Share your location in real-time while the travel page is open"]
    private lazy var tableRows = self.setupTableRows()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Settings"
        let logoutBtn = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(showLogoutDialog))
        navigationItem.setRightBarButton(logoutBtn, animated: false)

        view.addSubview(settingsTable)
        settingsTable.dataSource = self

        addConstraints()
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        // Settings table
        constraints += [
            settingsTable.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            settingsTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            settingsTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            settingsTable.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: Actions

    @objc func showLogoutDialog() {
        let dialog = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)

        let logoutAction = UIAlertAction(title: "Log out", style: .destructive, handler: { (_) -> Void in
            self.logout()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        dialog.run {
            $0.addAction(logoutAction)
            $0.addAction(cancelAction)
        }

        self.present(dialog, animated: true, completion: nil)
    }

    private func logout() {
        UserManager.clearUserData()
        self.present(LoginViewController.instance(), animated: true, completion: nil)
    }

    private func setupTableRows() -> [[UITableViewCell]] {
        return [
            [self.liveLocationCell],
        ]
    }

    @objc private func toggleLiveLocationPreference(toggle: UISwitch) {
        UserManager.setShouldShareLiveLocation(toggle.isOn)
    }

    // MARK: UI Element creators

    private func setupSettingsTable() -> UITableView {
        return UITableView(frame: CGRect.zero, style: .grouped).apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }

    private func setupLiveLocationToggle() -> UITableViewCell {
        return UITableViewCell().apply {
            $0.textLabel?.text = "Share live location"
            $0.detailTextLabel?.text = "Shares your live location while you have the travel page open."

            let toggle = UISwitch().apply {
                $0.setOn(UserManager.getShouldShareLiveLocation(), animated: false)
                $0.addTarget(self, action: #selector(toggleLiveLocationPreference(toggle:)), for: .valueChanged)
            }
            $0.accessoryView = toggle
        }
    }

}

extension AboutViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableRows[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.tableRows[indexPath.section][indexPath.row]
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.sectionFooters[section]
    }

}
