//
//  AboutViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2018-10-27.
//  Copyright © 2018 Studieresan. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        // Hide the top navigation bar in this view
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: Actions

    @IBAction func didTapLogout(_ sender: Any) {
        showLogoutDialog()
    }

    // MARK: Methods

    func showLogoutDialog() {
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

    func logout() {
        UserManager.clearToken()
        self.present(LoginViewController.instance(), animated: true, completion: nil)
    }

}
