//
//  StatusUpdateViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-05-29.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit
import CoreLocation

final class StatusUpdateViewController: UIViewController {

    // MARK: Properties

    private var locationManager = CLLocationManager()

    // MARK: UI Elements

    private lazy var statusTextfield: UITextView = self.setupTextView()
    private lazy var textViewPlaceholder: UILabel = self.setupTextViewPlaceHolder()
    private lazy var locationBar: UIView = self.setupLocationBar()
    private lazy var addLocationIcon: UIImageView = self.setupAddLocationIcon()
    private lazy var addLocationButton: UIButton = self.setupAddLocationButton()

    // Used for adjusting the bottom anchor of the location bar depending on
    // if the keyboard is visible or not
    private var locationBarKeyboardHiddenConstraint: NSLayoutConstraint?
    private var locationBarKeyboardVisibleConstraint: NSLayoutConstraint?

    // MARK: Constants

    static let statusFontSize: CGFloat = 24

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New status"
        view.backgroundColor = .white

        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationItem.setLeftBarButton(cancelBtn, animated: false)

        let submitBtn = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(submit))
        navigationItem.setRightBarButton(submitBtn, animated: false)
        navigationItem.rightBarButtonItem?.isEnabled = false

        view.addSubview(statusTextfield)
        statusTextfield.delegate = self

        view.addSubview(textViewPlaceholder)
        view.addSubview(locationBar)
        view.addSubview(addLocationIcon)
        view.addSubview(addLocationButton)

        addConstraints()

        locationManager.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
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
            statusTextfield.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 12),
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

        // Add location icon
        constraints += [
            addLocationIcon.centerYAnchor.constraint(equalTo: locationBar.centerYAnchor),
            addLocationIcon.leftAnchor.constraint(equalTo: locationBar.leftAnchor, constant: 14),
            addLocationIcon.widthAnchor.constraint(equalToConstant: 14),
            addLocationIcon.heightAnchor.constraint(equalToConstant: 16),
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

        var keyboardHeight = keyboardFrame.cgRectValue.height

        if #available(iOS 11.0, *) {
            let bottomInset = view.safeAreaInsets.bottom
            keyboardHeight -= bottomInset
        }

        locationBarKeyboardVisibleConstraint = locationBar.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,
                                                                                   constant: -keyboardHeight)

        locationBarKeyboardHiddenConstraint?.isActive = false
        locationBarKeyboardVisibleConstraint?.isActive = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if locationBarKeyboardHiddenConstraint == nil {
            locationBarKeyboardHiddenConstraint = locationBar.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
        }

        locationBarKeyboardVisibleConstraint?.isActive = false
        locationBarKeyboardHiddenConstraint?.isActive = true
    }

    @objc func onTapAddLocation() {
        addLocationButton.setTitle("Getting location...", for: .normal)
        locationManager.requestLocation()
    }

    // MARK: UI Element creators

    private func setupTextView() -> UITextView {
        return UITextView().apply {
            $0.font = .systemFont(ofSize: StatusUpdateViewController.statusFontSize)
            $0.textColor = .textColor
            $0.textContainerInset = .zero
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupTextViewPlaceHolder() -> UILabel {
        return UILabel().apply {
            $0.font = .systemFont(ofSize: StatusUpdateViewController.statusFontSize)
            $0.textColor = .lightGray
            $0.text = "What's happening?"
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupLocationBar() -> UIView {
        return UIView().apply {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupAddLocationIcon() -> UIImageView {
        let image = UIImage(named: "locationBarIcon")?.withRenderingMode(.alwaysTemplate)
        let icon = UIImageView(image: image).apply {
            $0.tintColor = .primary
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return icon
    }

    private func setupAddLocationButton() -> UIButton {
        return UIButton().apply {
            $0.setTitle("Add your location", for: .normal)
            $0.setTitleColor(.primary, for: .normal)
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

extension StatusUpdateViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            if error == nil {
                let locationName = placemarks?[0]
                self.addLocationButton.setTitle(locationName?.name, for: .normal)

                UIView.transition(with: self.addLocationButton, duration: 0.15, options: .transitionCrossDissolve, animations: {
                    self.addLocationButton.setTitleColor(.white, for: .normal)
                    self.locationBar.backgroundColor = .primary
                    self.addLocationIcon.tintColor = .white
                }, completion: nil)
            } else {
                self.addLocationButton.setTitle("Couldn't get location", for: .normal)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.addLocationButton.setTitle("Couldn't get location", for: .normal)
    }

}
