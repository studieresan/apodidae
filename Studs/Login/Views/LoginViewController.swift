//
//  LoginViewController.swift
//  Studs
//
//  Created by Willy Liu on 2019-02-23.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    // MARK: Properties

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

		emailTextField.tag = 1
		passwordTextField.tag = 2

        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Clear the error label on load
        errorLabel.text = ""

        viewModel.onErrorMsgChange = { [weak self] (errorMsg) in
            DispatchQueue.main.async {
                self?.errorLabel.text = errorMsg
            }
        }

        viewModel.onLoginChange = { [weak self] (isLoggedIn) in
            if isLoggedIn {
                DispatchQueue.main.async {
					let studsVC = StudsViewController()
					studsVC.modalPresentationStyle = .fullScreen
                    self?.present(studsVC, animated: true, completion: nil)
                }
            }
        }
    }
	
    // MARK: Actions

    @IBAction func didTapLogin(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text

        if email == "" || password == "" {
            return
        }

        viewModel.login(email: email!, password: password!)
        self.view.endEditing(true)
    }

    // Dismiss keyboard when tapping anywhere outside text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension LoginViewController: UITextFieldDelegate {
	internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField.tag == 1 { // email
			passwordTextField.becomeFirstResponder()
		} else if textField.tag == 2 { // password
			didTapLogin(textField)
		} else {
			return true
		}
		return false
   }
}
