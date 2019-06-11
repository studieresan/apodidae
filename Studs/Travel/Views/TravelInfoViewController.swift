//
//  TravelInfoViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2019-05-29.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum InfoType {
    case housing
    case contacts
}

final class TravelInfoViewController: UIViewController {

    // MARK: Properties

    private let infoType: InfoType
    private let dbRef = Database.database()

    // MARK: UI Elements

    private lazy var infoTextView: UITextView = self.setupTextView()

    // MARK: Lifecycle

    init(type: InfoType) {
        self.infoType = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        var ref: DatabaseReference

        switch infoType {
        case .housing:
            self.title = "Housing"
            ref = dbRef.reference(withPath: "housing")
        case .contacts:
            self.title = "Contacts"
            ref = dbRef.reference(withPath: "contacts")
        }

        let closeBtn = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView))
        navigationItem.setRightBarButton(closeBtn, animated: false)

        view.addSubview(infoTextView)

        addConstraints()

        ref.observeSingleEvent(of: .value) { snapshot in
            let text = snapshot.value as? String ?? ""
            self.infoTextView.text = text
        }
    }

    override func viewDidLayoutSubviews() {
        // Make sure textview is scrolled to top when loaded
        infoTextView.setContentOffset(.zero, animated: false)
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        // Text view
        constraints += [
            infoTextView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            infoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            infoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            infoTextView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: UI Element creators

    private func setupTextView() -> UITextView {
        return UITextView().apply {
            $0.isEditable = false
            $0.isSelectable = true
            $0.font = .systemFont(ofSize: 18)
            $0.textColor = .textColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.dataDetectorTypes = [.address, .link, .phoneNumber]
        }
    }
}
