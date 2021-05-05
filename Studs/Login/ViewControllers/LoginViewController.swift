//
//  LoginViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit
import WidgetKit

final class LoginViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var loginButton: StudsButton!
	@IBOutlet weak var errorLabel: UILabel!

	private enum TEXTFIELD_TAGS: Int {
		case email = 1
		case pass = 2
	}

    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

		emailTextField.tag = TEXTFIELD_TAGS.email.rawValue
		passwordTextField.tag = TEXTFIELD_TAGS.pass.rawValue

        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Clear the error label on load
        errorLabel.text = ""

        viewModel.onErrorMsgChange = { [weak self] (errorMsg) in
            DispatchQueue.main.async {
                self?.errorLabel.text = errorMsg
				self?.loginButton.isEnabled = true
            }
        }

        viewModel.onLoginChange = { [weak self] (isLoggedIn) in
            if isLoggedIn {
                DispatchQueue.main.async {
					let studsVC = self?.parent?.parent as? StudsViewController
					studsVC?.updateViewControllers()
                }
				//Reload widget when logging in
				if #available(iOS 14.0, *) {
					WidgetCenter.shared.reloadAllTimelines()
				}
            }
        }
    }

    // MARK: Actions

    @IBAction func didTapLogin(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text

        guard email != "" && password != "" else {
			errorLabel.text = "Ange giltig email och lösenord"
            return
        }

		self.view.endEditing(true)
		loginButton.isEnabled = false

        viewModel.login(email: email!, password: password!)
    }

    // Dismiss keyboard when tapping anywhere outside text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

//What happends when return is pressed
extension LoginViewController: UITextFieldDelegate {
	internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.tag == TEXTFIELD_TAGS.email.rawValue { // email
			passwordTextField.becomeFirstResponder()
		} else if textField.tag == TEXTFIELD_TAGS.pass.rawValue { // password
			didTapLogin(textField)
		} else {
			return true
		}
		return false
   }
}
