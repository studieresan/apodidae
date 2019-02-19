//
//  EventDetailViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-17.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class EventDetailViewController: UIViewController {

    // MARK: Properties

    public var event: Event?
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var companyName: UILabel!

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        // Show the top navigation bar in this view
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let event = event {
            companyName.text = event.companyName
        }
    }

    // MARK: Actions

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
