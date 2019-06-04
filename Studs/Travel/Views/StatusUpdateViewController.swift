//
//  StatusUpdateViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-05-29.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class StatusUpdateViewController: UIViewController {

    // MARK: UI Elements

    private lazy var statusTextfield: UITextView = self.setupTextView()
    private lazy var textViewPlaceholder: UILabel = self.setupTextViewPlaceHolder()
    private lazy var locationBar: UIView = self.setupLocationBar()
    private lazy var addLocationButton: UIButton = self.setupAddLocationButton()

    // Used for adjusting the bottom anchor of the location bar depending on
    // if the keyboard is visible or not
    private var locationBarKeyboardHiddenConstraint: NSLayoutConstraint?
    private var locationBarKeyboardVisibleConstraint: NSLayoutConstraint?

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
        statusTextfield.delegate = self

        view.addSubview(textViewPlaceholder)
        view.addSubview(locationBar)
        view.addSubview(addLocationButton)

        addConstraints()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)

        statusTextfield.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        // Textfield
        constraints += [
            statusTextfield.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 10),
            statusTextfield.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            statusTextfield.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            statusTextfield.bottomAnchor.constraint(equalTo: locationBar.topAnchor),
        ]

        // Textfield placeholder text
        constraints += [
            textViewPlaceholder.topAnchor.constraint(equalTo: statusTextfield.topAnchor, constant: 1),
            textViewPlaceholder.leftAnchor.constraint(equalTo: statusTextfield.leftAnchor, constant: 5),
        ]

        // Location bar
        constraints += [
            locationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            locationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            locationBar.heightAnchor.constraint(equalToConstant: 45),
        ]

        // Add location button
        constraints += [
            addLocationButton.leftAnchor.constraint(equalTo: locationBar.leftAnchor, constant: 40),
            addLocationButton.rightAnchor.constraint(equalTo: locationBar.rightAnchor),
            addLocationButton.centerYAnchor.constraint(equalTo: locationBar.centerYAnchor),
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

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        locationBarKeyboardVisibleConstraint = locationBar.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,
            constant: -keyboardFrame.cgRectValue.height)

        locationBarKeyboardHiddenConstraint?.isActive = false
        locationBarKeyboardVisibleConstraint?.isActive = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        locationBarKeyboardHiddenConstraint = locationBar.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)

        locationBarKeyboardVisibleConstraint?.isActive = false
        locationBarKeyboardHiddenConstraint?.isActive = true
    }

    @objc func onTapAddLocation() {
        print("Tapped")
    }

    // MARK: UI Element creators

    private func setupTextView() -> UITextView {
        return UITextView().apply {
            $0.font = .systemFont(ofSize: 18)
            $0.textColor = .textColor
            $0.textContainerInset = .zero
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupTextViewPlaceHolder() -> UILabel {
        return UILabel().apply {
            $0.font = .systemFont(ofSize: 18)
            $0.textColor = .veryLightGray
            $0.text = "What's happening?"
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupLocationBar() -> UIView {
        let bar = UIView().apply {
            $0.backgroundColor = .primary
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let icon = UIImageView(image: UIImage(named: "locationBarIcon")).apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        bar.addSubview(icon)

        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: bar.centerYAnchor),
            icon.leftAnchor.constraint(equalTo: bar.leftAnchor, constant: 12),
            icon.widthAnchor.constraint(equalToConstant: 14),
            icon.heightAnchor.constraint(equalToConstant: 16),
        ])

        return bar
    }

    private func setupAddLocationButton() -> UIButton {
        return UIButton().apply {
            $0.setTitle("Add location", for: .normal)
            $0.titleLabel?.textColor = .white
            $0.contentHorizontalAlignment = .left
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addTarget(self, action: #selector(onTapAddLocation), for: .touchUpInside)
        }
    }

}

extension StatusUpdateViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.textViewPlaceholder.isHidden = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.textViewPlaceholder.isHidden = false
        }
    }

}
