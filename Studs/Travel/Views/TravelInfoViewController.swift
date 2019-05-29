//
//  TravelInfoViewController.swift
//  Studs
//
//  Created by Michel Tabari on 2019-05-29.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class TravelInfoViewController: UIViewController {

    private let html: String

    private lazy var webView: UIWebView = self.setupWebView()
    private lazy var closeButton: UIImageView = self.setupCloseButton()

    init(html: String) {
        self.html = html
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(closeButton)
        addConstraints()
    }

    private func setupWebView() -> UIWebView {
        let webView = UIWebView(frame: view.frame)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.loadHTMLString(html, baseURL: nil)
        webView.backgroundColor = .clear
        return webView
    }

    private func setupCloseButton() -> UIImageView {
        let closeButton = UIImageView(image: UIImage(named: "closeBtn"))
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.isUserInteractionEnabled = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissView)))
        return closeButton
    }

    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }

    private func addConstraints() {
        var constraints: [NSLayoutConstraint] = []

        constraints += [
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]

        constraints += [
            closeButton.topAnchor.constraint(equalTo: webView.topAnchor, constant: 45),
            closeButton.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: -15),
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
