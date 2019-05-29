//
//  StatusUpdateViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-05-29.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class StatusUpdateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New status"
        view.backgroundColor = .white

        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.setLeftBarButton(cancelBtn, animated: false)

        let submitBtn = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submit))
        navigationItem.setRightBarButton(submitBtn, animated: false)
        navigationItem.rightBarButtonItem?.isEnabled = false

        addConstraints()
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        constraints += [

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
        return UITextField()
    }

}
