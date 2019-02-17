//
//  EventDetailViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-17.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var closeButton: UIButton!

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        // Show the top navigation bar in this view
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: Actions

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
