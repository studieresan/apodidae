//
//  StatusUpdateViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-05-29.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class StatusUpdateViewController: UIViewController {

    private lazy var statusTextfield: UITextField = self.setupTextfield()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New status"
        view.backgroundColor = .white

        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.setLeftBarButton(cancelBtn, animated: false)

        let submitBtn = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submit))
        navigationItem.setRightBarButton(submitBtn, animated: false)
        navigationItem.rightBarButtonItem?.isEnabled = false

        view.addSubview(statusTextfield)
        statusTextfield.becomeFirstResponder()

        addConstraints()
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        // Textfield
        // TODO: not working properly yet
        constraints += [
            statusTextfield.topAnchor.constraint(equalTo: view.topAnchor),
            statusTextfield.leftAnchor.constraint(equalTo: view.leftAnchor),
            statusTextfield.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusTextfield.heightAnchor.constraint(equalToConstant: 300),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: Event handlers

    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func submit() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UI Element creators

    private func setupTextfield() -> UITextField {
        return UITextField().apply {
            $0.backgroundColor = .gray
            $0.contentVerticalAlignment = .top
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

}
