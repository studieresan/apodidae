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

    private lazy var logoutBtn: UIButton = self.setupLogoutBtn()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(logoutBtn)

        addConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Hide the top navigation bar in this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        // Log out button
        constraints += [
            logoutBtn.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            logoutBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
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
        UserManager.clearToken()
        self.present(LoginViewController.instance(), animated: true, completion: nil)
    }

    // MARK: UI Element creators

    private func setupLogoutBtn() -> UIButton {
        return UIButton(type: .system).apply {
            $0.setTitle("Log out", for: .normal)
            $0.addTarget(self, action: #selector(showLogoutDialog), for: .touchUpInside)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

}
